import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/user_firestore_fields.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_league_dashboard_entity.dart';
import '../../domain/entities/manage_league_snapshot_entity.dart';
import '../utils/manage_league_snapshot_builder.dart';
import 'manage_league_dashboard_firestore.dart';
import 'manage_league_end_match_firestore.dart';
import 'manage_league_end_league_firestore.dart';
import 'manage_league_match_mutations_firestore.dart';

abstract class ManageLeagueRemoteDataSource {
  Future<ManageLeagueDashboardEntity> getDashboard(String competitionId);

  Future<void> startMatch({
    required String competitionId,
    required String matchId,
    String? streamUrl,
  });

  Future<void> updateMatchScores({required String competitionId, required String matchId, required int homeScore, required int awayScore});

  Future<String> addMatchEvent({
    required String competitionId,
    required String matchId,
    required ManageMatchEventKind kind,
    required String playerName,
    required String minuteLabel,
    required String title,
    required String subtitle,
  });

  Future<void> endMatch({required String competitionId, required String matchId, required int homeScore, required int awayScore});

  Future<void> updateMatchSchedule({
    required String competitionId,
    required String matchId,
    required DateTime kickoffAt,
  });

  Future<void> endLeague({
    required String competitionId,
    required String winnerDisplayName,
  });

  Future<List<ManageMatchEventEntity>> getMatchEvents({
    required String competitionId,
    required String matchId,
    required int limit,
  });

  ManageLeagueSnapshotEntity buildAdminMatchSnapshot({
    required String competitionId,
    required String leagueName,
    required String matchId,
    required List<LeagueFixtureSummaryEntity> fixtures,
    required Set<String> startedMatchIds,
  });

  Future<Map<String, String>> fetchUserPhotoUrls(Set<String> userIds);
}

class ManageLeagueRemoteDataSourceImpl implements ManageLeagueRemoteDataSource {
  ManageLeagueRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<ManageLeagueDashboardEntity> getDashboard(String competitionId) async {
    return getManageLeagueDashboardFromFirestore(
      firestore: _firestore,
      competitionId: competitionId,
    );
  }

  @override
  Future<void> startMatch({
    required String competitionId,
    required String matchId,
    String? streamUrl,
  }) async {
    await startMatchInFirestore(
      firestore: _firestore,
      competitionId: competitionId,
      matchId: matchId,
      streamUrl: streamUrl,
    );
  }
  @override
  Future<void> updateMatchScores({required String competitionId, required String matchId, required int homeScore, required int awayScore}) async {
    await updateMatchScoresInFirestore(
      firestore: _firestore,
      competitionId: competitionId,
      matchId: matchId,
      homeScore: homeScore,
      awayScore: awayScore,
    );
  }
  @override
  Future<String> addMatchEvent({
    required String competitionId,
    required String matchId,
    required ManageMatchEventKind kind,
    required String playerName,
    required String minuteLabel,
    required String title,
    required String subtitle,
  }) async {
    return addMatchEventInFirestore(
      firestore: _firestore,
      competitionId: competitionId,
      matchId: matchId,
      kind: kind,
      playerName: playerName,
      minuteLabel: minuteLabel,
      title: title,
      subtitle: subtitle,
    );
  }
  @override
  Future<void> endMatch({required String competitionId, required String matchId, required int homeScore, required int awayScore}) async {
    await endMatchInFirestore(
      firestore: _firestore,
      competitionId: competitionId,
      matchId: matchId,
      homeScore: homeScore,
      awayScore: awayScore,
    );
  }

  @override
  Future<void> updateMatchSchedule({
    required String competitionId,
    required String matchId,
    required DateTime kickoffAt,
  }) async {
    await updateMatchScheduleInFirestore(
      firestore: _firestore,
      competitionId: competitionId,
      matchId: matchId,
      kickoffAt: kickoffAt,
    );
  }

  @override
  Future<void> endLeague({
    required String competitionId,
    required String winnerDisplayName,
  }) async {
    await endLeagueInFirestore(
      firestore: _firestore,
      competitionId: competitionId,
      winnerDisplayName: winnerDisplayName,
    );
  }

  @override
  Future<List<ManageMatchEventEntity>> getMatchEvents({
    required String competitionId,
    required String matchId,
    required int limit,
  }) async {
    final snap = await _firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId)
        .collection(FirestoreCollections.events)
        .orderBy(LeagueFirestoreFields.createdAt, descending: true)
        .limit(limit)
        .get();

    return snap.docs.map((d) {
      final data = d.data();
      final kindRaw = data[LeagueFirestoreFields.eventKind] as String?;
      final kind = switch (kindRaw) {
        'yellowCard' => ManageMatchEventKind.yellowCard,
        'redCard' => ManageMatchEventKind.redCard,
        'substitution' => ManageMatchEventKind.substitution,
        _ => ManageMatchEventKind.goal,
      };
      return ManageMatchEventEntity(
        id: d.id,
        minuteLabel: data[LeagueFirestoreFields.eventMinuteLabel] as String? ?? '',
        title: data[LeagueFirestoreFields.eventTitle] as String? ?? '',
        subtitle: data[LeagueFirestoreFields.eventSubtitle] as String? ?? '',
        kind: kind,
      );
    }).toList();
  }

  @override
  Future<Map<String, String>> fetchUserPhotoUrls(Set<String> userIds) async {
    final out = <String, String>{};
    for (final uid in userIds) {
      if (uid.isEmpty) continue;
      final doc = await _firestore.collection(FirestoreCollections.users).doc(uid).get();
      final url = doc.data()?[UserFirestoreFields.photoUrl] as String?;
      if (url != null && url.trim().isNotEmpty) {
        out[uid] = url.trim();
      }
    }
    return out;
  }

  @override
  ManageLeagueSnapshotEntity buildAdminMatchSnapshot({
    required String competitionId,
    required String leagueName,
    required String matchId,
    required List<LeagueFixtureSummaryEntity> fixtures,
    required Set<String> startedMatchIds,
  }) {
    if (fixtures.isEmpty || matchId.isEmpty) {
      return emptyManageLeagueSnapshot(competitionId: competitionId, leagueName: leagueName);
    }
    final fixture = fixtures.firstWhere(
      (f) => f.matchId == matchId,
      orElse: () => fixtures.first,
    );
    return buildManageLeagueSnapshotFromFixture(
      competitionId: competitionId,
      leagueName: leagueName,
      fixture: fixture,
      startedMatchIds: startedMatchIds,
    );
  }
}

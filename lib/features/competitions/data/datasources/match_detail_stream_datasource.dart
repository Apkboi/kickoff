import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/utils/app_datetime_format.dart';
import '../../domain/entities/live_match_detail_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';

abstract class MatchDetailStreamDataSource {
  Stream<LiveMatchDetailEntity> watchMatch({
    required String competitionId,
    required String matchId,
  });
}

class MatchDetailStreamDataSourceImpl implements MatchDetailStreamDataSource {
  MatchDetailStreamDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<LiveMatchDetailEntity> watchMatch({
    required String competitionId,
    required String matchId,
  }) {
    final fixtureRef = _firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId);

    final eventsQuery = fixtureRef
        .collection(FirestoreCollections.events)
        .orderBy(LeagueFirestoreFields.createdAt, descending: true)
        .limit(10);

    return Stream<LiveMatchDetailEntity>.multi((controller) {
      Map<String, dynamic>? latestFixture;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> latestEvents = const [];

      StreamSubscription fixtureSub = fixtureRef.snapshots().listen(
        (fixtureSnap) {
          if (!fixtureSnap.exists) return;
          latestFixture = fixtureSnap.data();
          _emit(controller, fixtureId: matchId, fixtureData: latestFixture, eventsDocs: latestEvents);
        },
        onError: controller.addError,
      );

      StreamSubscription eventsSub = eventsQuery.snapshots().listen(
        (eventsSnap) {
          latestEvents = eventsSnap.docs;
          if (latestFixture != null) {
            _emit(controller, fixtureId: matchId, fixtureData: latestFixture!, eventsDocs: latestEvents);
          }
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await fixtureSub.cancel();
        await eventsSub.cancel();
      };
    });
  }

  void _emit(
    StreamController<LiveMatchDetailEntity> controller, {
    required String fixtureId,
    required Map<String, dynamic>? fixtureData,
    required List<QueryDocumentSnapshot<Map<String, dynamic>>> eventsDocs,
  }) {
    if (fixtureData == null) return;

    final homeName = fixtureData[LeagueFirestoreFields.homeName] as String? ?? 'Home';
    final awayName = fixtureData[LeagueFirestoreFields.awayName] as String? ?? 'Away';
    final matchTitle = '$homeName vs $awayName';

    final status = fixtureData[LeagueFirestoreFields.status] as String? ?? 'scheduled';
    final isLive = status == 'live';
    final homeScore = (fixtureData[LeagueFirestoreFields.homeScore] as num?)?.toInt() ?? 0;
    final awayScore = (fixtureData[LeagueFirestoreFields.awayScore] as num?)?.toInt() ?? 0;

    final startedAtTs = fixtureData[LeagueFirestoreFields.startedAt] as Timestamp?;
    final kickoffAt = (fixtureData[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
    final matchClock = switch (status) {
      'live' => _formatElapsed(startedAtTs),
      'finished' || 'ft' => 'FT',
      _ => kickoffAt != null ? AppDateTimeFormat.kickoffFull(kickoffAt) : '—',
    };

    final statusLabel = switch (status) {
      'live' => 'LIVE',
      'finished' || 'ft' => 'FULL-TIME',
      _ => 'SCHEDULED',
    };

    final round = (fixtureData[LeagueFirestoreFields.round] as num?)?.toInt() ?? 0;
    final venueLine = round > 0 ? 'Matchday $round' : 'Matchday';
    final streamUrl = fixtureData[LeagueFirestoreFields.streamUrl] as String?;

    final recentEvents = eventsDocs.map((d) {
      final data = d.data();
      return ManageMatchEventEntity(
        id: d.id,
        minuteLabel: data[LeagueFirestoreFields.eventMinuteLabel] as String? ?? '',
        title: data[LeagueFirestoreFields.eventTitle] as String? ?? (data[LeagueFirestoreFields.eventPlayerName] as String? ?? 'Player'),
        subtitle: data[LeagueFirestoreFields.eventSubtitle] as String? ?? '',
        kind: _kindFromFirestore(data[LeagueFirestoreFields.eventKind] as String?),
      );
    }).toList();

    controller.add(
      LiveMatchDetailEntity(
        matchId: fixtureId,
        matchTitle: matchTitle,
        homeName: homeName,
        awayName: awayName,
        homeScore: homeScore,
        awayScore: awayScore,
        matchClock: matchClock,
        statusLabel: statusLabel,
        isLive: isLive,
        venueLine: venueLine,
        streamUrl: streamUrl,
        recentEvents: recentEvents,
        kickoffAt: kickoffAt,
        matchStatusRaw: status,
      ),
    );
  }

  String _formatElapsed(Timestamp? startedAt) {
    if (startedAt == null) return 'LIVE';
    final elapsed = DateTime.now().difference(startedAt.toDate());
    final totalSeconds = max(0, elapsed.inSeconds);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  ManageMatchEventKind _kindFromFirestore(String? kind) {
    return switch (kind) {
      'goal' => ManageMatchEventKind.goal,
      'yellowCard' => ManageMatchEventKind.yellowCard,
      'redCard' => ManageMatchEventKind.redCard,
      'substitution' => ManageMatchEventKind.substitution,
      _ => ManageMatchEventKind.goal,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../models/competition_model.dart';
import '../models/league_detail_model.dart';
import '../utils/league_fixture_firestore_mapper.dart';
import '../../domain/entities/league_admin_entity.dart';
import '../../domain/entities/league_card_status.dart';
import '../../domain/entities/standing_row_entity.dart';

abstract class CompetitionRemoteDataSource {
  Future<List<CompetitionModel>> getCompetitions();

  Future<LeagueDetailModel?> getCompetitionById(String id);

  Stream<List<StandingRowEntity>> watchCompetitionStandings(String competitionId);
}

class CompetitionRemoteDataSourceImpl implements CompetitionRemoteDataSource {
  CompetitionRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<CompetitionModel>> getCompetitions() async {
    final now = DateTime.now();
    // Avoid composite index (published + createdAt): filter + sort in memory.
    final snap = await _firestore
        .collection(FirestoreCollections.leagues)
        .where(LeagueFirestoreFields.published, isEqualTo: true)
        .limit(100)
        .get();

    final docs = snap.docs.toList()
      ..sort((a, b) {
        final ta = a.data()[LeagueFirestoreFields.createdAt];
        final tb = b.data()[LeagueFirestoreFields.createdAt];
        if (ta is! Timestamp && tb is! Timestamp) return 0;
        if (ta is! Timestamp) return 1;
        if (tb is! Timestamp) return -1;
        return tb.compareTo(ta);
      });

    return docs.take(80).map((d) {
      final data = d.data();
      final endDate = (data[LeagueFirestoreFields.endDate] as Timestamp?)?.toDate();
      final status = endDate != null && endDate.isBefore(now)
          ? LeagueCardStatus.live
          : LeagueCardStatus.upcoming;

      final prizePool = data[LeagueFirestoreFields.prizePool] as num?;
      final xpPoolLabel = prizePool == null
          ? null
          : '${prizePool.toStringAsFixed(0)} XP Pool';

      final logoUrl = (data[LeagueFirestoreFields.logoUrl] as String?)?.trim();
      final bannerUrl = (data[LeagueFirestoreFields.bannerUrl] as String?)?.trim();

      return CompetitionModel(
        id: d.id,
        name: data[LeagueFirestoreFields.name] as String? ?? 'League',
        teamCount: (data[LeagueFirestoreFields.participantCount] as num?)?.toInt() ?? 0,
        matchdayLabel: 'Season',
        status: status,
        xpPoolLabel: xpPoolLabel,
        showMeBadge: false,
        logoUrl: logoUrl != null && logoUrl.isNotEmpty ? logoUrl : null,
        bannerUrl: bannerUrl != null && bannerUrl.isNotEmpty ? bannerUrl : null,
      );
    }).toList();
  }

  @override
  Future<LeagueDetailModel?> getCompetitionById(String id) async {
    final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc(id);
    final leagueSnap = await leagueRef.get();
    if (!leagueSnap.exists) return null;

    final data = leagueSnap.data() ?? <String, dynamic>{};
    final membersSnap = await leagueRef.collection('members').get();
    final membersDocs = membersSnap.docs;

    final adminUserIds = membersDocs
        .where((d) => (d.data()[LeagueFirestoreFields.isAdmin] as bool?) == true)
        .map((d) => (d.data()[LeagueFirestoreFields.userId] as String?) ?? d.id)
        .where((v) => v.isNotEmpty)
        .toList();

    final admins = membersDocs
        .where((d) => (d.data()[LeagueFirestoreFields.isAdmin] as bool?) == true)
        .map((d) {
          final m = d.data();
          return LeagueAdminEntity(
            name: m[LeagueFirestoreFields.displayName] as String? ?? 'Admin',
            role: 'League admin',
            tag: 'ADM',
          );
        })
        .toList();

    final standingsSnap = await leagueRef.collection('standings').get();
    final standingDocs = standingsSnap.docs.map((d) => d.data()).toList();
    standingDocs.sort((a, b) {
      final pa = (a[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      final pb = (b[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      if (pb != pa) return pb.compareTo(pa);
      final gfa = ((a[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
          ((a[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
      final gfb = ((b[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
          ((b[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
      return gfb.compareTo(gfa);
    });

    final standings = <StandingRowEntity>[];
    for (var i = 0; i < standingDocs.length; i++) {
      final s = standingDocs[i];
      final mp = (s[LeagueFirestoreFields.played] as num?)?.toInt() ?? 0;
      final gf = (s[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0;
      final ga = (s[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0;
      final points = (s[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      standings.add(
        StandingRowEntity(
          rank: i + 1,
          teamName: s[LeagueFirestoreFields.displayName] as String? ?? 'Player',
          matchesPlayed: mp,
          goalsFor: gf,
          goalsAgainst: ga,
          points: points,
          highlightRank: i == 0,
        ),
      );
    }

    const fixturesPreviewLimit = 4;

    final maxRoundSnap = await leagueRef
        .collection('fixtures')
        .orderBy(LeagueFirestoreFields.round, descending: true)
        .limit(1)
        .get();
    final totalWeeks =
        maxRoundSnap.docs.isNotEmpty ? ((maxRoundSnap.docs.first.data()[LeagueFirestoreFields.round] as num?)?.toInt() ?? 1) : 1;

    final liveSnap = await leagueRef
        .collection('fixtures')
        .where(LeagueFirestoreFields.status, isEqualTo: 'live')
        .limit(1)
        .get();
    final isLive = liveSnap.docs.isNotEmpty;

    final firstFixtureSnap = await leagueRef
        .collection('fixtures')
        .orderBy(LeagueFirestoreFields.matchIndex)
        .limit(1)
        .get();
    final firstFixtureDoc = firstFixtureSnap.docs.isNotEmpty ? firstFixtureSnap.docs.first : null;

    final matchHome = (firstFixtureDoc?.data()[LeagueFirestoreFields.homeName] as String?) ?? 'Home';
    final matchAway = (firstFixtureDoc?.data()[LeagueFirestoreFields.awayName] as String?) ?? 'Away';

    final previewSnap = await leagueRef
        .collection('fixtures')
        .orderBy(LeagueFirestoreFields.matchIndex)
        .limit(fixturesPreviewLimit)
        .get();
    final spectatorFixtures = previewSnap.docs.map(leagueFixtureSummaryFromFirestoreDoc).toList();

    final logoUrl = (data[LeagueFirestoreFields.logoUrl] as String?)?.trim();
    final bannerUrl = (data[LeagueFirestoreFields.bannerUrl] as String?)?.trim();

    return LeagueDetailModel(
      id: leagueSnap.id,
      name: data[LeagueFirestoreFields.name] as String? ?? 'League',
      seasonLabel: 'SEASON',
      isLive: isLive,
      logoUrl: logoUrl != null && logoUrl.isNotEmpty ? logoUrl : null,
      bannerUrl: bannerUrl != null && bannerUrl.isNotEmpty ? bannerUrl : null,
      teamCount: (data[LeagueFirestoreFields.participantCount] as num?)?.toInt() ?? membersDocs.length,
      currentWeek: totalWeeks,
      totalWeeks: totalWeeks,
      standings: standings,
      admins: admins,
      adminUserIds: adminUserIds,
      matchOfWeekHome: matchHome,
      matchOfWeekAway: matchAway,
      matchOfWeekTimeLabel: 'Scheduled',
      matchOfWeekBadgeLabel: isLive ? 'LIVE' : 'NEXT UP',
      fixtures: spectatorFixtures,
    );
  }

  @override
  Stream<List<StandingRowEntity>> watchCompetitionStandings(String competitionId) {
    final standingsRef = _firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.standings);

    return standingsRef.snapshots().map((snap) {
      final rows = snap.docs.map((d) => d.data()).toList();
      rows.sort((a, b) {
        final pa = (a[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
        final pb = (b[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
        if (pb != pa) return pb.compareTo(pa);
        final gfa = ((a[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
            ((a[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
        final gfb = ((b[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
            ((b[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
        return gfb.compareTo(gfa);
      });
      final standings = <StandingRowEntity>[];
      for (var i = 0; i < rows.length; i++) {
        final s = rows[i];
        final mp = (s[LeagueFirestoreFields.played] as num?)?.toInt() ?? 0;
        final gf = (s[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0;
        final ga = (s[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0;
        final points = (s[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
        standings.add(
          StandingRowEntity(
            rank: i + 1,
            teamName: s[LeagueFirestoreFields.displayName] as String? ?? 'Player',
            matchesPlayed: mp,
            goalsFor: gf,
            goalsAgainst: ga,
            points: points,
            highlightRank: i == 0,
          ),
        );
      }
      return standings;
    });
  }
}

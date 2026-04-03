import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/constants/user_firestore_fields.dart';
import '../models/competition_model.dart';
import '../models/league_detail_model.dart';
import '../utils/league_fixture_firestore_mapper.dart';
import '../../domain/entities/league_admin_entity.dart';
import '../../domain/entities/league_card_status.dart';
import '../../domain/entities/standing_row_entity.dart';

abstract class CompetitionRemoteDataSource {
  Future<List<CompetitionModel>> getCompetitions();

  Stream<List<CompetitionModel>> watchCompetitions();

  Future<LeagueDetailModel?> getCompetitionById(String id);

  Stream<List<StandingRowEntity>> watchCompetitionStandings(String competitionId);
}

class CompetitionRemoteDataSourceImpl implements CompetitionRemoteDataSource {
  CompetitionRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<CompetitionModel>> getCompetitions() async {
    final snap = await _firestore
        .collection(FirestoreCollections.leagues)
        .where(LeagueFirestoreFields.published, isEqualTo: true)
        .limit(100)
        .get();

    return _competitionModelsFromDocs(snap.docs);
  }

  @override
  Stream<List<CompetitionModel>> watchCompetitions() {
    return _firestore
        .collection(FirestoreCollections.leagues)
        .where(LeagueFirestoreFields.published, isEqualTo: true)
        .limit(100)
        .snapshots()
        .map((snap) => _competitionModelsFromDocs(snap.docs));
  }

  List<CompetitionModel> _competitionModelsFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final now = DateTime.now();
    final sorted = docs.toList()
      ..sort((a, b) {
        final ta = a.data()[LeagueFirestoreFields.createdAt];
        final tb = b.data()[LeagueFirestoreFields.createdAt];
        if (ta is! Timestamp && tb is! Timestamp) return 0;
        if (ta is! Timestamp) return 1;
        if (tb is! Timestamp) return -1;
        return tb.compareTo(ta);
      });

    return sorted.take(80).map((d) {
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
      final maxP = (data[LeagueFirestoreFields.maxParticipants] as num?)?.toInt() ?? 32;

      return CompetitionModel(
        id: d.id,
        name: data[LeagueFirestoreFields.name] as String? ?? 'Tournament',
        teamCount: (data[LeagueFirestoreFields.participantCount] as num?)?.toInt() ?? 0,
        matchdayLabel: 'Season',
        status: status,
        maxParticipants: maxP,
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
    final creatorUserId = data[LeagueFirestoreFields.creatorId] as String?;
    final membersSnap = await leagueRef.collection(FirestoreCollections.members).get();
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

    final adminParticipantIds = _adminParticipantIdsFromMemberDocs(membersDocs);
    final standingsSnap = await leagueRef.collection(FirestoreCollections.standings).get();
    final standingDocsFiltered = standingsSnap.docs.where((d) {
      final row = d.data();
      final pid = (row[LeagueFirestoreFields.participantId] as String?) ?? d.id;
      return !adminParticipantIds.contains(pid);
    }).toList();
    standingDocsFiltered.sort((a, b) {
      final ad = a.data();
      final bd = b.data();
      final pa = (ad[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      final pb = (bd[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      if (pb != pa) return pb.compareTo(pa);
      final gfa = ((ad[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
          ((ad[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
      final gfb = ((bd[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
          ((bd[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
      return gfb.compareTo(gfa);
    });

    final standings = <StandingRowEntity>[];
    for (var i = 0; i < standingDocsFiltered.length; i++) {
      final s = standingDocsFiltered[i].data();
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
    var spectatorFixtures = previewSnap.docs.map(leagueFixtureSummaryFromFirestoreDoc).toList();
    final photoUserIds = <String>{};
    for (final f in spectatorFixtures) {
      final h = f.homeId;
      final a = f.awayId;
      if (h != null && h.isNotEmpty) photoUserIds.add(h);
      if (a != null && a.isNotEmpty) photoUserIds.add(a);
    }
    final photoMap = await _fetchUserPhotoUrls(photoUserIds);
    spectatorFixtures = spectatorFixtures
        .map(
          (f) => f.copyWith(
            homeAvatarUrl: f.homeId != null ? photoMap[f.homeId!] : null,
            awayAvatarUrl: f.awayId != null ? photoMap[f.awayId!] : null,
          ),
        )
        .toList();

    final logoUrl = (data[LeagueFirestoreFields.logoUrl] as String?)?.trim();
    final bannerUrl = (data[LeagueFirestoreFields.bannerUrl] as String?)?.trim();

    return LeagueDetailModel(
      id: leagueSnap.id,
      name: data[LeagueFirestoreFields.name] as String? ?? 'Tournament',
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
      creatorUserId: creatorUserId,
    );
  }

  @override
  Stream<List<StandingRowEntity>> watchCompetitionStandings(String competitionId) {
    final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc(competitionId);
    final standingsRef = leagueRef.collection(FirestoreCollections.standings);
    final membersRef = leagueRef.collection(FirestoreCollections.members);

    return Stream.multi((controller) {
      QuerySnapshot<Map<String, dynamic>>? lastStandings;
      QuerySnapshot<Map<String, dynamic>>? lastMembers;

      void emit() {
        if (lastStandings == null || lastMembers == null) return;
        final adminIds = _adminParticipantIdsFromMemberDocs(lastMembers!.docs);
        final standings = _standingEntitiesFromStandingDocs(lastStandings!.docs, adminIds);
        controller.add(standings);
      }

      late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> subStandings;
      late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> subMembers;

      subStandings = standingsRef.snapshots().listen(
        (snap) {
          lastStandings = snap;
          emit();
        },
        onError: controller.addError,
      );

      subMembers = membersRef.snapshots().listen(
        (snap) {
          lastMembers = snap;
          emit();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await subStandings.cancel();
        await subMembers.cancel();
      };
    });
  }

  Set<String> _adminParticipantIdsFromMemberDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    return docs
        .where((d) => (d.data()[LeagueFirestoreFields.isAdmin] as bool?) == true)
        .map((d) => d.id)
        .where((id) => id.isNotEmpty)
        .toSet();
  }

  List<StandingRowEntity> _standingEntitiesFromStandingDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> standingDocs,
    Set<String> adminParticipantIds,
  ) {
    final filtered = standingDocs.where((d) {
      final row = d.data();
      final pid = (row[LeagueFirestoreFields.participantId] as String?) ?? d.id;
      return !adminParticipantIds.contains(pid);
    }).toList();

    filtered.sort((a, b) {
      final ad = a.data();
      final bd = b.data();
      final pa = (ad[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      final pb = (bd[LeagueFirestoreFields.points] as num?)?.toInt() ?? 0;
      if (pb != pa) return pb.compareTo(pa);
      final gfa = ((ad[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
          ((ad[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
      final gfb = ((bd[LeagueFirestoreFields.goalsFor] as num?)?.toInt() ?? 0) -
          ((bd[LeagueFirestoreFields.goalsAgainst] as num?)?.toInt() ?? 0);
      return gfb.compareTo(gfa);
    });

    final standings = <StandingRowEntity>[];
    for (var i = 0; i < filtered.length; i++) {
      final s = filtered[i].data();
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
  }

  Future<Map<String, String>> _fetchUserPhotoUrls(Set<String> userIds) async {
    final out = <String, String>{};
    await Future.wait(
      userIds.map((uid) async {
        if (uid.isEmpty) return;
        final doc = await _firestore.collection(FirestoreCollections.users).doc(uid).get();
        final url = doc.data()?[UserFirestoreFields.photoUrl] as String?;
        if (url != null && url.trim().isNotEmpty) {
          out[uid] = url.trim();
        }
      }),
    );
    return out;
  }
}

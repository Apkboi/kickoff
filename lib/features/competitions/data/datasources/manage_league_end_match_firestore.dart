import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';
import 'user_global_stats_after_match.dart';

Future<void> endMatchInFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
  required String matchId,
  required int homeScore,
  required int awayScore,
}) async {
  final leagueRef = firestore.collection(FirestoreCollections.leagues).doc(competitionId);
  final fixtureRef = leagueRef.collection(FirestoreCollections.fixtures).doc(matchId);

  try {
    final fixtureSnap = await fixtureRef.get();
    final fixtureData = fixtureSnap.data() ?? <String, dynamic>{};
    final status = (fixtureData[LeagueFirestoreFields.status] as String?)?.toLowerCase();
    if (status == 'finished' || status == 'ft') {
      return;
    }

    String? homeId = fixtureData[LeagueFirestoreFields.homeId] as String?;
    String? awayId = fixtureData[LeagueFirestoreFields.awayId] as String?;
    final homeName = fixtureData[LeagueFirestoreFields.homeName] as String?;
    final awayName = fixtureData[LeagueFirestoreFields.awayName] as String?;

    if ((homeId == null || awayId == null) && homeName != null && awayName != null) {
      // Backward compatibility for older fixtures missing homeId/awayId.
      homeId ??= await _resolveStandingParticipantIdByName(
        leagueRef: leagueRef,
        name: homeName,
      );
      awayId ??= await _resolveStandingParticipantIdByName(
        leagueRef: leagueRef,
        name: awayName,
      );
    }

    if (homeId == null || awayId == null) {
      throw const FirebaseDataException('Missing home/away ids');
    }

    final result = _resultFor(homeScore: homeScore, awayScore: awayScore);

    await firestore.runTransaction((tx) async {
      final homeStandingRef = leagueRef.collection(FirestoreCollections.standings).doc(homeId);
      final awayStandingRef = leagueRef.collection(FirestoreCollections.standings).doc(awayId);

      // Firestore transactions require all reads before writes.
      final homeSnap = await tx.get(homeStandingRef);
      final awaySnap = await tx.get(awayStandingRef);

      final home = homeSnap.data() ?? <String, dynamic>{};
      final away = awaySnap.data() ?? <String, dynamic>{};

      final currentHome = _standingFromFirestore(home);
      final currentAway = _standingFromFirestore(away);

      tx.update(fixtureRef, {
        LeagueFirestoreFields.status: 'finished',
        LeagueFirestoreFields.endedAt: FieldValue.serverTimestamp(),
        LeagueFirestoreFields.homeScore: homeScore,
        LeagueFirestoreFields.awayScore: awayScore,
        LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
      });

      tx.set(
        homeStandingRef,
        {
          LeagueFirestoreFields.participantId: homeId,
          LeagueFirestoreFields.displayName: home[LeagueFirestoreFields.displayName] as String? ?? '',
          LeagueFirestoreFields.played: currentHome.played + 1,
          LeagueFirestoreFields.won: currentHome.won + result.homeWon,
          LeagueFirestoreFields.drawn: currentHome.drawn + result.homeDrawn,
          LeagueFirestoreFields.lost: currentHome.lost + result.homeLost,
          LeagueFirestoreFields.goalsFor: currentHome.goalsFor + homeScore,
          LeagueFirestoreFields.goalsAgainst: currentHome.goalsAgainst + awayScore,
          LeagueFirestoreFields.points: currentHome.points + result.homePoints,
          LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      tx.set(
        awayStandingRef,
        {
          LeagueFirestoreFields.participantId: awayId,
          LeagueFirestoreFields.displayName: away[LeagueFirestoreFields.displayName] as String? ?? '',
          LeagueFirestoreFields.played: currentAway.played + 1,
          LeagueFirestoreFields.won: currentAway.won + result.awayWon,
          LeagueFirestoreFields.drawn: currentAway.drawn + result.awayDrawn,
          LeagueFirestoreFields.lost: currentAway.lost + result.awayLost,
          LeagueFirestoreFields.goalsFor: currentAway.goalsFor + awayScore,
          LeagueFirestoreFields.goalsAgainst: currentAway.goalsAgainst + homeScore,
          LeagueFirestoreFields.points: currentAway.points + result.awayPoints,
          LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    });

    try {
      await applyUserGlobalMatchStatsAfterMatch(
        firestore: firestore,
        homeParticipantId: homeId,
        awayParticipantId: awayId,
        result: (
          homeWon: result.homeWon,
          awayWon: result.awayWon,
          homeDrawn: result.homeDrawn,
          awayDrawn: result.awayDrawn,
          homeLost: result.homeLost,
          awayLost: result.awayLost,
        ),
      );
    } catch (_) {
      // Standings updated; user profile stats are best-effort.
    }
  } on FirebaseDataException {
    rethrow;
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message ?? 'Failed to end match');
  } catch (_) {
    throw const FirebaseDataException('Failed to end match');
  }
}

Future<String?> _resolveStandingParticipantIdByName({
  required DocumentReference<Map<String, dynamic>> leagueRef,
  required String name,
}) async {
  final snap = await leagueRef
      .collection(FirestoreCollections.standings)
      .where(LeagueFirestoreFields.displayName, isEqualTo: name)
      .limit(1)
      .get();
  if (snap.docs.isEmpty) return null;
  return snap.docs.first.id;
}

class _StandingSnapshot {
  const _StandingSnapshot({
    required this.played,
    required this.won,
    required this.drawn,
    required this.lost,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
  });

  final int played;
  final int won;
  final int drawn;
  final int lost;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
}

_StandingSnapshot _standingFromFirestore(Map<String, dynamic> data) {
  int i(String f) => (data[f] as num?)?.toInt() ?? 0;
  return _StandingSnapshot(
    played: i(LeagueFirestoreFields.played),
    won: i(LeagueFirestoreFields.won),
    drawn: i(LeagueFirestoreFields.drawn),
    lost: i(LeagueFirestoreFields.lost),
    goalsFor: i(LeagueFirestoreFields.goalsFor),
    goalsAgainst: i(LeagueFirestoreFields.goalsAgainst),
    points: i(LeagueFirestoreFields.points),
  );
}

({int homeWon, int awayWon, int homeDrawn, int awayDrawn, int homeLost, int awayLost, int homePoints, int awayPoints})
_resultFor({required int homeScore, required int awayScore}) {
  if (homeScore > awayScore) {
    return (homeWon: 1, awayWon: 0, homeDrawn: 0, awayDrawn: 0, homeLost: 0, awayLost: 1, homePoints: 3, awayPoints: 0);
  }
  if (homeScore < awayScore) {
    return (homeWon: 0, awayWon: 1, homeDrawn: 0, awayDrawn: 0, homeLost: 1, awayLost: 0, homePoints: 0, awayPoints: 3);
  }
  return (homeWon: 0, awayWon: 0, homeDrawn: 1, awayDrawn: 1, homeLost: 0, awayLost: 0, homePoints: 1, awayPoints: 1);
}


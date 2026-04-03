import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/constants/prediction_firestore_fields.dart';
import '../../../../core/constants/user_firestore_fields.dart';
import '../../domain/entities/match_prediction_view_entity.dart';
import 'match_prediction_mapper.dart';

/// Realtime panel + optional settle when the match is finished (correct score ⇒ +3 league points).
///
/// Firestore rules must allow authenticated users to write their own prediction before kickoff − 3m,
/// and to update `predictionScores/{uid}` only via controlled logic (prefer Cloud Functions in prod).
abstract class MatchPredictionRemoteDataSource {
  Stream<MatchPredictionViewEntity> watchPanel({
    required String leagueId,
    required String matchId,
    required String? userId,
  });

  /// League-wide prediction points (`leagues/{id}/predictionScores`).
  Stream<List<PredictionLeaderboardEntryEntity>> watchLeagueLeaderboard(String leagueId);

  Future<void> submitPrediction({
    required String leagueId,
    required String matchId,
    required String userId,
    required int homePredicted,
    required int awayPredicted,
  });
}

class MatchPredictionRemoteDataSourceImpl implements MatchPredictionRemoteDataSource {
  MatchPredictionRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<PredictionLeaderboardEntryEntity>> watchLeagueLeaderboard(String leagueId) {
    final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc(leagueId);
    final q = leagueRef
        .collection(FirestoreCollections.predictionScores)
        .orderBy(PredictionFirestoreFields.totalPoints, descending: true)
        .limit(25);
    return q.snapshots().map((snap) => MatchPredictionMapper.leaderboardFromDocs(snap.docs));
  }

  @override
  Stream<MatchPredictionViewEntity> watchPanel({
    required String leagueId,
    required String matchId,
    required String? userId,
  }) {
    final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc(leagueId);
    final fixtureRef = leagueRef.collection(FirestoreCollections.fixtures).doc(matchId);
    // Index: collection predictionScores — orderBy totalPoints DESC (Firebase may prompt once).
    final leaderboardQuery = leagueRef
        .collection(FirestoreCollections.predictionScores)
        .orderBy(PredictionFirestoreFields.totalPoints, descending: true)
        .limit(15);

    return Stream<MatchPredictionViewEntity>.multi((controller) {
      Map<String, dynamic>? fixtureData;
      var fixtureResolved = false;
      Map<String, dynamic>? predictionData;
      List<QueryDocumentSnapshot<Map<String, dynamic>>> leaderDocs = const [];

      Future<void> settle() async {
        if (userId == null || fixtureData == null) return;
        await _trySettle(
          leagueRef: leagueRef,
          fixtureRef: fixtureRef,
          userId: userId,
          fixtureData: fixtureData!,
          predictionData: predictionData,
        );
      }

      void emit() {
        if (!fixtureResolved) {
          return;
        }
        final fd = fixtureData ?? <String, dynamic>{};
        final view = MatchPredictionMapper.build(
          leagueId: leagueId,
          matchId: matchId,
          userId: userId,
          fixtureData: fd,
          predictionData: predictionData,
          leaderboardDocs: leaderDocs,
        );
        if (!controller.isClosed) controller.add(view);
        unawaited(settle());
      }

      late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> fixtureSub;
      StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? predSub;
      late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> leaderSub;

      fixtureSub = fixtureRef.snapshots().listen(
        (snap) {
          fixtureResolved = true;
          fixtureData = snap.exists ? snap.data() : null;
          emit();
        },
        onError: controller.addError,
      );

      if (userId != null) {
        predSub = fixtureRef
            .collection(FirestoreCollections.predictions)
            .doc(userId)
            .snapshots()
            .listen(
          (snap) {
            predictionData = snap.data();
            emit();
          },
          onError: controller.addError,
        );
      }

      leaderSub = leaderboardQuery.snapshots().listen(
        (snap) {
          leaderDocs = snap.docs;
          emit();
        },
        onError: controller.addError,
      );

      controller.onCancel = () async {
        await fixtureSub.cancel();
        await predSub?.cancel();
        await leaderSub.cancel();
      };
    });
  }

  Future<void> _trySettle({
    required DocumentReference<Map<String, dynamic>> leagueRef,
    required DocumentReference<Map<String, dynamic>> fixtureRef,
    required String userId,
    required Map<String, dynamic> fixtureData,
    required Map<String, dynamic>? predictionData,
  }) async {
    if (predictionData == null) return;
    final st = fixtureData[LeagueFirestoreFields.status] as String? ?? '';
    if (st != 'finished' && st != 'ft') return;
    final awarded = (predictionData[PredictionFirestoreFields.pointsAwarded] as num?)?.toInt() ?? 0;
    if (awarded > 0) return;
    final hp = (predictionData[PredictionFirestoreFields.homePredicted] as num?)?.toInt() ?? -999;
    final ap = (predictionData[PredictionFirestoreFields.awayPredicted] as num?)?.toInt() ?? -999;
    final fh = (fixtureData[LeagueFirestoreFields.homeScore] as num?)?.toInt() ?? 0;
    final fa = (fixtureData[LeagueFirestoreFields.awayScore] as num?)?.toInt() ?? 0;
    if (hp != fh || ap != fa) return;

    final userRef = _firestore.collection(FirestoreCollections.users).doc(userId);
    final predRef = fixtureRef.collection(FirestoreCollections.predictions).doc(userId);
    final scoreRef = leagueRef.collection(FirestoreCollections.predictionScores).doc(userId);

    try {
      await _firestore.runTransaction((txn) async {
        final pSnap = await txn.get(predRef);
        if (!pSnap.exists) return;
        final d = pSnap.data()!;
        if (((d[PredictionFirestoreFields.pointsAwarded] as num?)?.toInt() ?? 0) > 0) return;
        final uSnap = await txn.get(userRef);
        final uData = uSnap.data();
        final name = (uData?[UserFirestoreFields.displayName] as String?)?.trim();
        final photo = (uData?[UserFirestoreFields.photoUrl] as String?)?.trim();

        txn.update(predRef, {PredictionFirestoreFields.pointsAwarded: MatchPredictionMapper.pointsPerCorrect});
        txn.set(
          scoreRef,
          {
            PredictionFirestoreFields.totalPoints: FieldValue.increment(MatchPredictionMapper.pointsPerCorrect),
            UserFirestoreFields.displayName: name?.isNotEmpty == true ? name : 'Player',
            if (photo != null && photo.isNotEmpty) UserFirestoreFields.photoUrl: photo,
            LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
          },
          SetOptions(merge: true),
        );
      });
    } catch (_) {}
  }

  @override
  Future<void> submitPrediction({
    required String leagueId,
    required String matchId,
    required String userId,
    required int homePredicted,
    required int awayPredicted,
  }) async {
    if (homePredicted < 0 || homePredicted > 99 || awayPredicted < 0 || awayPredicted > 99) {
      throw ArgumentError('Invalid score');
    }
    final fixtureRef = _firestore
        .collection(FirestoreCollections.leagues)
        .doc(leagueId)
        .collection(FirestoreCollections.fixtures)
        .doc(matchId);
    final snap = await fixtureRef.get();
    final data = snap.data();
    if (data == null) throw StateError('Fixture missing');
    final status = data[LeagueFirestoreFields.status] as String? ?? '';
    if (status == 'live' || status == 'finished' || status == 'ft') {
      throw StateError('Predictions closed');
    }
    final ko = (data[LeagueFirestoreFields.kickoffAt] as Timestamp?)?.toDate();
    if (ko == null) throw StateError('Kickoff missing');
    final deadline = ko.subtract(MatchPredictionMapper.predictionCloseLead);
    if (!DateTime.now().isBefore(deadline)) throw StateError('Predictions closed');

    await fixtureRef.collection(FirestoreCollections.predictions).doc(userId).set({
      PredictionFirestoreFields.homePredicted: homePredicted,
      PredictionFirestoreFields.awayPredicted: awayPredicted,
      PredictionFirestoreFields.pointsAwarded: 0,
      PredictionFirestoreFields.createdAt: FieldValue.serverTimestamp(),
    });
  }
}

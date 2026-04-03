import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/user_firestore_fields.dart';

/// Updates global `users/{uid}` aggregates when a fixture ends.
/// Assumes [homeParticipantId] / [awayParticipantId] match `users` doc ids (solo leagues).
Future<void> applyUserGlobalMatchStatsAfterMatch({
  required FirebaseFirestore firestore,
  required String homeParticipantId,
  required String awayParticipantId,
  required ({
    int homeWon,
    int awayWon,
    int homeDrawn,
    int awayDrawn,
    int homeLost,
    int awayLost,
  })
      result,
}) async {
  final batch = firestore.batch();

  void bump(
    String uid, {
    required int winDelta,
    required int lossDelta,
    required int drawDelta,
  }) {
    final ref = firestore.collection(FirestoreCollections.users).doc(uid);
    batch.set(
      ref,
      {
        UserFirestoreFields.matchesPlayed: FieldValue.increment(1),
        UserFirestoreFields.wins: FieldValue.increment(winDelta),
        UserFirestoreFields.losses: FieldValue.increment(lossDelta),
        UserFirestoreFields.draws: FieldValue.increment(drawDelta),
        UserFirestoreFields.xpPoints: FieldValue.increment(
          winDelta * 50 + drawDelta * 20 + lossDelta * 5,
        ),
        UserFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  bump(
    homeParticipantId,
    winDelta: result.homeWon,
    lossDelta: result.homeLost,
    drawDelta: result.homeDrawn,
  );
  bump(
    awayParticipantId,
    winDelta: result.awayWon,
    lossDelta: result.awayLost,
    drawDelta: result.awayDrawn,
  );

  await batch.commit();
}

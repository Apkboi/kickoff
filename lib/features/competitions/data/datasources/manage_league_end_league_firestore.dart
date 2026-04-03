import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';

Future<void> endLeagueInFirestore({
  required FirebaseFirestore firestore,
  required String competitionId,
  required String winnerDisplayName,
}) async {
  try {
    final ref = firestore.collection(FirestoreCollections.leagues).doc(competitionId);
    await ref.update({
      LeagueFirestoreFields.leagueStatus: 'completed',
      LeagueFirestoreFields.winnerDisplayName: winnerDisplayName.trim(),
      LeagueFirestoreFields.completedAt: FieldValue.serverTimestamp(),
      LeagueFirestoreFields.updatedAt: FieldValue.serverTimestamp(),
    });
  } on FirebaseException catch (e) {
    throw FirebaseDataException(e.message ?? 'Failed to end league');
  } catch (_) {
    throw const FirebaseDataException('Failed to end league');
  }
}

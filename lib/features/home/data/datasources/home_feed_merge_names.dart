import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';

Future<void> mergeMissingLeagueNames(
  FirebaseFirestore firestore,
  Map<String, String> map,
  Iterable<String> ids,
) async {
  final missing = ids.where((id) => !map.containsKey(id)).toSet();
  await Future.wait(missing.map((id) async {
    final snap = await firestore.collection(FirestoreCollections.leagues).doc(id).get();
    map[id] = snap.data()?[LeagueFirestoreFields.name] as String? ?? 'League';
  }));
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../utils/league_fixture_firestore_mapper.dart';

abstract class LeagueFixturesLiveRemoteDataSource {
  Stream<List<LeagueFixtureSummaryEntity>> watchFixtures({
    required String competitionId,
  });
}

class LeagueFixturesLiveRemoteDataSourceImpl implements LeagueFixturesLiveRemoteDataSource {
  LeagueFixturesLiveRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<LeagueFixtureSummaryEntity>> watchFixtures({
    required String competitionId,
  }) {
    return _firestore
        .collection(FirestoreCollections.leagues)
        .doc(competitionId)
        .collection(FirestoreCollections.fixtures)
        .orderBy(LeagueFirestoreFields.matchIndex)
        .snapshots()
        .map((snap) {
          final fixtures = snap.docs.map(leagueFixtureSummaryFromFirestoreDoc).toList();
          fixtures.sort((a, b) {
            final aDate = a.kickoffAt;
            final bDate = b.kickoffAt;
            if (aDate == null && bDate == null) return a.matchId.compareTo(b.matchId);
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return aDate.compareTo(bDate);
          });
          return fixtures;
        });
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/league_fixtures_cursor_entity.dart';
import '../../domain/entities/league_fixtures_page_entity.dart';
import '../utils/league_fixture_firestore_mapper.dart';

abstract class LeagueFixturesPaginationRemoteDataSource {
  Future<LeagueFixturesPageEntity> getFixturesPage({
    required String competitionId,
    required int limit,
    required LeagueFixturesCursorEntity? cursor,
  });

  Future<LeagueFixturesPageEntity> getFixturesPageStartingAtMatchId({
    required String competitionId,
    required String matchId,
    required int limit,
  });
}

class LeagueFixturesPaginationRemoteDataSourceImpl implements LeagueFixturesPaginationRemoteDataSource {
  LeagueFixturesPaginationRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  static const _fixtures = 'fixtures';

  @override
  Future<LeagueFixturesPageEntity> getFixturesPage({
    required String competitionId,
    required int limit,
    required LeagueFixturesCursorEntity? cursor,
  }) async {
    try {
      final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc(competitionId);

      Query<Map<String, dynamic>> query = leagueRef
          .collection(_fixtures)
          .orderBy(LeagueFirestoreFields.matchIndex)
          .limit(limit);

      if (cursor != null) {
        query = query.startAfter([cursor.lastMatchIndex]);
      }

      final snap = await query.get();
      final fixtures = snap.docs.map(leagueFixtureSummaryFromFirestoreDoc).toList();
      fixtures.sort((a, b) {
        final aDate = a.kickoffAt;
        final bDate = b.kickoffAt;
        if (aDate == null && bDate == null) return a.matchId.compareTo(b.matchId);
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return aDate.compareTo(bDate);
      });

      final nextCursor = snap.docs.length < limit
          ? null
          : _cursorFromDoc(snap.docs.last);

      return LeagueFixturesPageEntity(fixtures: fixtures, nextCursor: nextCursor);
    } on FirebaseDataException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Failed to load fixtures');
    } catch (_) {
      throw const FirebaseDataException('Failed to load fixtures');
    }
  }

  @override
  Future<LeagueFixturesPageEntity> getFixturesPageStartingAtMatchId({
    required String competitionId,
    required String matchId,
    required int limit,
  }) async {
    try {
      final leagueRef = _firestore.collection(FirestoreCollections.leagues).doc(competitionId);

      final cursorDoc = await leagueRef.collection(_fixtures).doc(matchId).get();
      if (!cursorDoc.exists) {
        return const LeagueFixturesPageEntity(fixtures: [], nextCursor: null);
      }

      final data = cursorDoc.data() ?? <String, dynamic>{};
      final cursorMatchIndex = (data[LeagueFirestoreFields.matchIndex] as num?)?.toInt() ?? 0;

      final snap = await leagueRef
          .collection(_fixtures)
          .orderBy(LeagueFirestoreFields.matchIndex)
          .startAt([cursorMatchIndex])
          .limit(limit)
          .get();

      final fixtures = snap.docs.map(leagueFixtureSummaryFromFirestoreDoc).toList();
      fixtures.sort((a, b) {
        final aDate = a.kickoffAt;
        final bDate = b.kickoffAt;
        if (aDate == null && bDate == null) return a.matchId.compareTo(b.matchId);
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return aDate.compareTo(bDate);
      });
      final nextCursor = snap.docs.length < limit ? null : _cursorFromDoc(snap.docs.last);
      return LeagueFixturesPageEntity(fixtures: fixtures, nextCursor: nextCursor);
    } on FirebaseException catch (e) {
      throw FirebaseDataException(e.message ?? 'Failed to load fixtures');
    } catch (_) {
      throw const FirebaseDataException('Failed to load fixtures');
    }
  }

  LeagueFixturesCursorEntity _cursorFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final lastMatchIndex = (data[LeagueFirestoreFields.matchIndex] as num?)?.toInt() ?? 0;
    return LeagueFixturesCursorEntity(lastMatchIndex: lastMatchIndex, lastMatchId: doc.id);
  }
}


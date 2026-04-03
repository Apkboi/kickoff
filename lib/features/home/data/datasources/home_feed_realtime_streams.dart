import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/constants/league_firestore_fields.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_trending_league_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import 'home_feed_firestore_loader.dart';
import 'home_feed_per_league_realtime.dart';

/// Realtime Firestore streams for home sections.
///
/// Uses per-league subcollection listeners (see [HomeFeedPerLeagueRealtime]) so you do **not**
/// need collection-group indexes on `fixtures`. Optional: add indexes in Firebase Console if you
/// switch back to `collectionGroup` queries.
abstract final class HomeFeedRealtimeStreams {
  static Stream<List<HomeLiveMatchEntity>> watchLiveMatches(FirebaseFirestore firestore) {
    return HomeFeedPerLeagueRealtime.watchLiveMatches(firestore);
  }

  static Stream<List<HomeUpcomingFixtureEntity>> watchUpcomingMatches(
    FirebaseFirestore firestore,
  ) {
    return HomeFeedPerLeagueRealtime.watchUpcomingMatches(firestore);
  }

  static Stream<List<HomeTrendingLeagueEntity>> watchTrendingLeagues(FirebaseFirestore firestore) {
    return firestore
        .collection(FirestoreCollections.leagues)
        .limit(100)
        .snapshots()
        .map((snap) {
      final docs = snap.docs
          .where((d) => d.data()[LeagueFirestoreFields.published] == true)
          .toList()
        ..sort((a, b) {
          final ta = a.data()[LeagueFirestoreFields.createdAt];
          final tb = b.data()[LeagueFirestoreFields.createdAt];
          if (ta is! Timestamp && tb is! Timestamp) return 0;
          if (ta is! Timestamp) return 1;
          if (tb is! Timestamp) return -1;
          return tb.compareTo(ta);
        });
      return HomeFeedFirestoreLoader.mapTrendingFromPublishedDocs(docs);
    });
  }
}

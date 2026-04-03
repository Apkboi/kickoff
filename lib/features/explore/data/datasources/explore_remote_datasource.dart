import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../explore_league_mapper.dart';
import '../explore_mock_feed.dart';
import '../../domain/entities/explore_feed_entity.dart';
import '../../domain/entities/explore_league_card_entity.dart';
import '../../domain/entities/explore_suggested_row_entity.dart';

abstract class ExploreRemoteDataSource {
  Future<ExploreFeedEntity> getFeed();

  Stream<ExploreFeedEntity> watchFeed();
}

class ExploreRemoteDataSourceImpl implements ExploreRemoteDataSource {
  ExploreRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<ExploreFeedEntity> getFeed() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final fromFs = await _loadPublishedLeagues();
    if (fromFs.isEmpty) {
      return ExploreMockFeed.build();
    }
    return _buildFeed(fromFs);
  }

  @override
  Stream<ExploreFeedEntity> watchFeed() {
    return _firestore.collection(FirestoreCollections.leagues).limit(60).snapshots().map((snap) {
      final fromFs = _publishedCardsFromDocs(snap.docs);
      if (fromFs.isEmpty) {
        return ExploreMockFeed.build();
      }
      return _buildFeed(fromFs);
    });
  }

  List<ExploreLeagueCardEntity> _publishedCardsFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    try {
      final filtered = docs.where((d) => d.data()['published'] == true).toList()
        ..sort((a, b) {
          final ta = a.data()['createdAt'];
          final tb = b.data()['createdAt'];
          if (ta is! Timestamp && tb is! Timestamp) return 0;
          if (ta is! Timestamp) return 1;
          if (tb is! Timestamp) return -1;
          return tb.compareTo(ta);
        });

      return filtered
          .map((d) => ExploreLeagueMapper.fromMap(d.id, d.data()))
          .take(24)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<ExploreLeagueCardEntity>> _loadPublishedLeagues() async {
    try {
      final snap = await _firestore
          .collection(FirestoreCollections.leagues)
          .limit(60)
          .get();

      return _publishedCardsFromDocs(snap.docs);
    } catch (_) {
      return [];
    }
  }

  ExploreFeedEntity _buildFeed(List<ExploreLeagueCardEntity> grid) {
    final trending = <ExploreLeagueCardEntity>[
      if (grid.isNotEmpty)
        grid[0].copyWith(
          isLive: true,
          trendingSubtitle: grid[0].title.toUpperCase(),
          trendingTitleLarge: 'OPEN REGISTRATION',
        ),
      if (grid.length > 1)
        grid[1].copyWith(
          trendingSubtitle: grid[1].sportTag,
          trendingTitleLarge: 'JOIN NOW',
        ),
    ];

    final suggested = <ExploreSuggestedRowEntity>[];
    for (var i = 0; i < grid.length && i < 3; i++) {
      final g = grid[i];
      suggested.add(
        ExploreSuggestedRowEntity(
          leagueId: g.id,
          categoryLine: '${g.sportTag} • TOURNAMENT',
          title: g.title,
          statusLine: g.footerRightValue,
          isFull: false,
          thumbnailIndex: i % 3,
        ),
      );
    }

    return ExploreFeedEntity(
      gridLeagues: grid,
      trending: trending,
      suggested: suggested,
    );
  }
}

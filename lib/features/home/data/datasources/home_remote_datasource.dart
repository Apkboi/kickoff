import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_trending_league_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import 'home_feed_realtime_streams.dart';

abstract class HomeRemoteDataSource {
  Stream<List<HomeLiveMatchEntity>> watchLiveMatches();

  Stream<List<HomeUpcomingFixtureEntity>> watchUpcomingMatches();

  Stream<List<HomeTrendingLeagueEntity>> watchTrendingLeagues();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<HomeLiveMatchEntity>> watchLiveMatches() {
    return HomeFeedRealtimeStreams.watchLiveMatches(_firestore);
  }

  @override
  Stream<List<HomeUpcomingFixtureEntity>> watchUpcomingMatches() {
    return HomeFeedRealtimeStreams.watchUpcomingMatches(_firestore);
  }

  @override
  Stream<List<HomeTrendingLeagueEntity>> watchTrendingLeagues() {
    return HomeFeedRealtimeStreams.watchTrendingLeagues(_firestore);
  }
}

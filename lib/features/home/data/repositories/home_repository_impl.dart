import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_trending_league_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Stream<List<HomeLiveMatchEntity>> watchLiveMatches() {
    return _remoteDataSource.watchLiveMatches();
  }

  @override
  Stream<List<HomeUpcomingFixtureEntity>> watchUpcomingMatches() {
    return _remoteDataSource.watchUpcomingMatches();
  }

  @override
  Stream<List<HomeTrendingLeagueEntity>> watchTrendingLeagues() {
    return _remoteDataSource.watchTrendingLeagues();
  }
}

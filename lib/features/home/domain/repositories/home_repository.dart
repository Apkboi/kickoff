import '../entities/home_live_match_entity.dart';
import '../entities/home_trending_league_entity.dart';
import '../entities/home_upcoming_fixture_entity.dart';

abstract class HomeRepository {
  Stream<List<HomeLiveMatchEntity>> watchLiveMatches();

  Stream<List<HomeUpcomingFixtureEntity>> watchUpcomingMatches();

  Stream<List<HomeTrendingLeagueEntity>> watchTrendingLeagues();
}

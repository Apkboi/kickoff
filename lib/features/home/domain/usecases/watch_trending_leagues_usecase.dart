import '../../../../core/domain/no_params.dart';
import '../entities/home_trending_league_entity.dart';
import '../repositories/home_repository.dart';

class WatchTrendingLeaguesUseCase {
  WatchTrendingLeaguesUseCase(this._repository);

  final HomeRepository _repository;

  Stream<List<HomeTrendingLeagueEntity>> call(NoParams params) {
    return _repository.watchTrendingLeagues();
  }
}

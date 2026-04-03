import '../../../../core/domain/no_params.dart';
import '../entities/home_upcoming_fixture_entity.dart';
import '../repositories/home_repository.dart';

class WatchUpcomingMatchesUseCase {
  WatchUpcomingMatchesUseCase(this._repository);

  final HomeRepository _repository;

  Stream<List<HomeUpcomingFixtureEntity>> call(NoParams params) {
    return _repository.watchUpcomingMatches();
  }
}

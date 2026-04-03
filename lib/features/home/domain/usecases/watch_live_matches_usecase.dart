import '../../../../core/domain/no_params.dart';
import '../entities/home_live_match_entity.dart';
import '../repositories/home_repository.dart';

class WatchLiveMatchesUseCase {
  WatchLiveMatchesUseCase(this._repository);

  final HomeRepository _repository;

  Stream<List<HomeLiveMatchEntity>> call(NoParams params) {
    return _repository.watchLiveMatches();
  }
}

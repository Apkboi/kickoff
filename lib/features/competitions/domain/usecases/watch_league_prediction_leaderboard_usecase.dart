import '../entities/match_prediction_view_entity.dart';
import '../repositories/match_prediction_repository.dart';

class WatchLeaguePredictionLeaderboardParams {
  const WatchLeaguePredictionLeaderboardParams({required this.leagueId});

  final String leagueId;
}

class WatchLeaguePredictionLeaderboardUseCase {
  WatchLeaguePredictionLeaderboardUseCase(this._repository);

  final MatchPredictionRepository _repository;

  Stream<List<PredictionLeaderboardEntryEntity>> call(WatchLeaguePredictionLeaderboardParams params) {
    return _repository.watchLeagueLeaderboard(params.leagueId);
  }
}

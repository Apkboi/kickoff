import '../entities/match_prediction_view_entity.dart';
import '../repositories/match_prediction_repository.dart';

class WatchMatchPredictionParams {
  const WatchMatchPredictionParams({
    required this.leagueId,
    required this.matchId,
    required this.userId,
  });

  final String leagueId;
  final String matchId;
  final String? userId;
}

class WatchMatchPredictionUseCase {
  WatchMatchPredictionUseCase(this._repository);

  final MatchPredictionRepository _repository;

  Stream<MatchPredictionViewEntity> call(WatchMatchPredictionParams params) {
    return _repository.watchPanel(
      leagueId: params.leagueId,
      matchId: params.matchId,
      userId: params.userId,
    );
  }
}

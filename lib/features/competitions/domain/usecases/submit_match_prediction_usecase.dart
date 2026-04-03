import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/match_prediction_repository.dart';

class SubmitMatchPredictionParams {
  const SubmitMatchPredictionParams({
    required this.leagueId,
    required this.matchId,
    required this.userId,
    required this.homePredicted,
    required this.awayPredicted,
  });

  final String leagueId;
  final String matchId;
  final String userId;
  final int homePredicted;
  final int awayPredicted;
}

class SubmitMatchPredictionUseCase {
  SubmitMatchPredictionUseCase(this._repository);

  final MatchPredictionRepository _repository;

  Future<Either<Failure, void>> call(SubmitMatchPredictionParams params) {
    return _repository.submitPrediction(
      leagueId: params.leagueId,
      matchId: params.matchId,
      userId: params.userId,
      homePredicted: params.homePredicted,
      awayPredicted: params.awayPredicted,
    );
  }
}

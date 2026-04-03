import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/match_prediction_view_entity.dart';

abstract class MatchPredictionRepository {
  Stream<MatchPredictionViewEntity> watchPanel({
    required String leagueId,
    required String matchId,
    required String? userId,
  });

  Stream<List<PredictionLeaderboardEntryEntity>> watchLeagueLeaderboard(String leagueId);

  Future<Either<Failure, void>> submitPrediction({
    required String leagueId,
    required String matchId,
    required String userId,
    required int homePredicted,
    required int awayPredicted,
  });
}

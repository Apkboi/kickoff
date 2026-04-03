import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/match_prediction_view_entity.dart';
import '../../domain/repositories/match_prediction_repository.dart';
import '../datasources/match_prediction_remote_datasource.dart';

class MatchPredictionRepositoryImpl implements MatchPredictionRepository {
  MatchPredictionRepositoryImpl(this._remote);

  final MatchPredictionRemoteDataSource _remote;

  @override
  Stream<MatchPredictionViewEntity> watchPanel({
    required String leagueId,
    required String matchId,
    required String? userId,
  }) {
    return _remote.watchPanel(leagueId: leagueId, matchId: matchId, userId: userId);
  }

  @override
  Stream<List<PredictionLeaderboardEntryEntity>> watchLeagueLeaderboard(String leagueId) {
    return _remote.watchLeagueLeaderboard(leagueId);
  }

  @override
  Future<Either<Failure, void>> submitPrediction({
    required String leagueId,
    required String matchId,
    required String userId,
    required int homePredicted,
    required int awayPredicted,
  }) async {
    try {
      await _remote.submitPrediction(
        leagueId: leagueId,
        matchId: matchId,
        userId: userId,
        homePredicted: homePredicted,
        awayPredicted: awayPredicted,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

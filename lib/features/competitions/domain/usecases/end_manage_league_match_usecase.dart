import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/manage_league_repository.dart';

class EndManageLeagueMatchParams extends Equatable {
  const EndManageLeagueMatchParams({
    required this.competitionId,
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
  });

  final String competitionId;
  final String matchId;
  final int homeScore;
  final int awayScore;

  @override
  List<Object?> get props => [competitionId, matchId, homeScore, awayScore];
}

class EndManageLeagueMatchUseCase {
  const EndManageLeagueMatchUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, Unit>> call(EndManageLeagueMatchParams params) {
    return _repository.endMatch(
      competitionId: params.competitionId,
      matchId: params.matchId,
      homeScore: params.homeScore,
      awayScore: params.awayScore,
    );
  }
}


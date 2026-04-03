import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/manage_league_repository.dart';

class EndLeagueCompetitionParams extends Equatable {
  const EndLeagueCompetitionParams({
    required this.competitionId,
    required this.winnerDisplayName,
  });

  final String competitionId;
  final String winnerDisplayName;

  @override
  List<Object?> get props => [competitionId, winnerDisplayName];
}

class EndLeagueCompetitionUseCase {
  const EndLeagueCompetitionUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, Unit>> call(EndLeagueCompetitionParams params) {
    return _repository.endLeague(
      competitionId: params.competitionId,
      winnerDisplayName: params.winnerDisplayName,
    );
  }
}

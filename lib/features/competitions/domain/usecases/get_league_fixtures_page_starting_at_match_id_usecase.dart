import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_fixtures_page_entity.dart';
import '../repositories/league_fixtures_repository.dart';

class GetLeagueFixturesPageStartingAtMatchIdParams extends Equatable {
  const GetLeagueFixturesPageStartingAtMatchIdParams({
    required this.competitionId,
    required this.matchId,
    required this.limit,
  });

  final String competitionId;
  final String matchId;
  final int limit;

  @override
  List<Object?> get props => [competitionId, matchId, limit];
}

class GetLeagueFixturesPageStartingAtMatchIdUseCase {
  const GetLeagueFixturesPageStartingAtMatchIdUseCase(this._repository);

  final LeagueFixturesRepository _repository;

  Future<Either<Failure, LeagueFixturesPageEntity>> call(
    GetLeagueFixturesPageStartingAtMatchIdParams params,
  ) {
    return _repository.getFixturesPageStartingAtMatchId(
      competitionId: params.competitionId,
      matchId: params.matchId,
      limit: params.limit,
    );
  }
}


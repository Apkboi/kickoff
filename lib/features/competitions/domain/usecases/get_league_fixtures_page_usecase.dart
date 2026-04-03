import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_fixtures_cursor_entity.dart';
import '../entities/league_fixtures_page_entity.dart';
import '../repositories/league_fixtures_repository.dart';

class GetLeagueFixturesPageParams extends Equatable {
  const GetLeagueFixturesPageParams({
    required this.competitionId,
    required this.limit,
    required this.cursor,
  });

  final String competitionId;
  final int limit;
  final LeagueFixturesCursorEntity? cursor;

  @override
  List<Object?> get props => [competitionId, limit, cursor];
}

class GetLeagueFixturesPageUseCase {
  const GetLeagueFixturesPageUseCase(this._repository);

  final LeagueFixturesRepository _repository;

  Future<Either<Failure, LeagueFixturesPageEntity>> call(GetLeagueFixturesPageParams params) {
    return _repository.getFixturesPage(
      competitionId: params.competitionId,
      limit: params.limit,
      cursor: params.cursor,
    );
  }
}


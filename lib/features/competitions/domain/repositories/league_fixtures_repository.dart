import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_fixtures_cursor_entity.dart';
import '../entities/league_fixtures_page_entity.dart';
import '../entities/league_fixture_summary_entity.dart';

abstract class LeagueFixturesRepository {
  Future<Either<Failure, LeagueFixturesPageEntity>> getFixturesPage({
    required String competitionId,
    required int limit,
    LeagueFixturesCursorEntity? cursor,
  });

  Future<Either<Failure, LeagueFixturesPageEntity>> getFixturesPageStartingAtMatchId({
    required String competitionId,
    required String matchId,
    required int limit,
  });

  Stream<List<LeagueFixtureSummaryEntity>> watchFixtures({
    required String competitionId,
  });
}


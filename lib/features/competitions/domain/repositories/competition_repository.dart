import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/competition_entity.dart';
import '../entities/league_detail_entity.dart';
import '../entities/standing_row_entity.dart';

abstract class CompetitionRepository {
  Future<Either<Failure, List<CompetitionEntity>>> getCompetitions();

  Stream<List<CompetitionEntity>> watchCompetitions();

  Future<Either<Failure, LeagueDetailEntity>> getCompetitionById(String id);

  Stream<List<StandingRowEntity>> watchCompetitionStandings(String competitionId);
}

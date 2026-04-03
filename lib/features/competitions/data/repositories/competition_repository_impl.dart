import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/competition_entity.dart';
import '../../domain/entities/league_detail_entity.dart';
import '../../domain/entities/standing_row_entity.dart';
import '../../domain/repositories/competition_repository.dart';
import '../datasources/competition_remote_datasource.dart';

class CompetitionRepositoryImpl implements CompetitionRepository {
  const CompetitionRepositoryImpl(this._remoteDataSource);

  final CompetitionRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, List<CompetitionEntity>>> getCompetitions() async {
    try {
      final competitions = await _remoteDataSource.getCompetitions();
      return Right(competitions);
    } catch (_) {
      return const Left(UnknownFailure('Unable to load competitions'));
    }
  }

  @override
  Stream<List<CompetitionEntity>> watchCompetitions() {
    return _remoteDataSource.watchCompetitions();
  }

  @override
  Future<Either<Failure, LeagueDetailEntity>> getCompetitionById(String id) async {
    try {
      final detail = await _remoteDataSource.getCompetitionById(id);
      if (detail == null) {
        return const Left(UnknownFailure('League not found'));
      }
      return Right(detail);
    } catch (_) {
      return const Left(UnknownFailure('Unable to load league'));
    }
  }

  @override
  Stream<List<StandingRowEntity>> watchCompetitionStandings(String competitionId) {
    return _remoteDataSource.watchCompetitionStandings(competitionId);
  }
}

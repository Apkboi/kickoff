import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/league_fixtures_cursor_entity.dart';
import '../../domain/entities/league_fixtures_page_entity.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/repositories/league_fixtures_repository.dart';
import '../datasources/league_fixtures_live_remote_datasource.dart';
import '../datasources/league_fixtures_pagination_remote_datasource.dart';

class LeagueFixturesRepositoryImpl implements LeagueFixturesRepository {
  const LeagueFixturesRepositoryImpl(this._remote, this._liveRemote);

  final LeagueFixturesPaginationRemoteDataSource _remote;
  final LeagueFixturesLiveRemoteDataSource _liveRemote;

  @override
  Future<Either<Failure, LeagueFixturesPageEntity>> getFixturesPage({
    required String competitionId,
    required int limit,
    LeagueFixturesCursorEntity? cursor,
  }) async {
    try {
      final page = await _remote.getFixturesPage(
        competitionId: competitionId,
        limit: limit,
        cursor: cursor,
      );
      return Right(page);
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Unable to load fixtures'));
    }
  }

  @override
  Future<Either<Failure, LeagueFixturesPageEntity>> getFixturesPageStartingAtMatchId({
    required String competitionId,
    required String matchId,
    required int limit,
  }) async {
    try {
      final page = await _remote.getFixturesPageStartingAtMatchId(
        competitionId: competitionId,
        matchId: matchId,
        limit: limit,
      );
      return Right(page);
    } on FirebaseDataException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(UnknownFailure('Unable to load fixtures'));
    }
  }

  @override
  Stream<List<LeagueFixtureSummaryEntity>> watchFixtures({
    required String competitionId,
  }) {
    return _liveRemote.watchFixtures(competitionId: competitionId);
  }
}


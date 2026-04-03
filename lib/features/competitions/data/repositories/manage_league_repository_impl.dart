import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_league_dashboard_entity.dart';
import '../../domain/entities/manage_league_snapshot_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../../domain/repositories/manage_league_repository.dart';
import '../datasources/manage_league_remote_datasource.dart';

class ManageLeagueRepositoryImpl implements ManageLeagueRepository {
  const ManageLeagueRepositoryImpl(this._remote);

  final ManageLeagueRemoteDataSource _remote;

  @override
  Future<Either<Failure, ManageLeagueDashboardEntity>> getDashboard(String competitionId) async {
    try {
      final dashboard = await _remote.getDashboard(competitionId);
      if (dashboard.fixtures.isEmpty) return Right(dashboard);
      final selected = dashboard.fixtures.firstWhere(
        (f) => f.matchId == dashboard.selectedMatchId,
        orElse: () => dashboard.fixtures.first,
      );
      final ids = <String>{};
      if (selected.homeId != null && selected.homeId!.isNotEmpty) ids.add(selected.homeId!);
      if (selected.awayId != null && selected.awayId!.isNotEmpty) ids.add(selected.awayId!);
      if (ids.isEmpty) return Right(dashboard);
      final urls = await _remote.fetchUserPhotoUrls(ids);
      return Right(
        ManageLeagueDashboardEntity(
          fixtures: dashboard.fixtures,
          selectedMatchId: dashboard.selectedMatchId,
          snapshot: dashboard.snapshot.copyWith(
            homePhotoUrl: selected.homeId != null ? urls[selected.homeId] : null,
            awayPhotoUrl: selected.awayId != null ? urls[selected.awayId] : null,
          ),
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure('Unable to load league'));
    }
  }

  @override
  Future<Either<Failure, ManageLeagueSnapshotEntity>> getAdminMatchSnapshot({
    required String competitionId,
    required String leagueName,
    required String matchId,
    required List<LeagueFixtureSummaryEntity> fixtures,
    required Set<String> startedMatchIds,
  }) async {
    try {
      final snapshot = _remote.buildAdminMatchSnapshot(
        competitionId: competitionId,
        leagueName: leagueName,
        matchId: matchId,
        fixtures: fixtures,
        startedMatchIds: startedMatchIds,
      );
      if (fixtures.isEmpty) return Right(snapshot);
      final fixture = fixtures.firstWhere(
        (f) => f.matchId == matchId,
        orElse: () => fixtures.first,
      );
      final ids = <String>{};
      if (fixture.homeId != null && fixture.homeId!.isNotEmpty) ids.add(fixture.homeId!);
      if (fixture.awayId != null && fixture.awayId!.isNotEmpty) ids.add(fixture.awayId!);
      if (ids.isEmpty) return Right(snapshot);
      final urls = await _remote.fetchUserPhotoUrls(ids);
      return Right(
        snapshot.copyWith(
          homePhotoUrl: fixture.homeId != null ? urls[fixture.homeId] : null,
          awayPhotoUrl: fixture.awayId != null ? urls[fixture.awayId] : null,
        ),
      );
    } catch (_) {
      return const Left(UnknownFailure('Unable to load match'));
    }
  }

  @override
  Future<Either<Failure, Unit>> startMatch({
    required String competitionId,
    required String matchId,
    String? streamUrl,
  }) async {
    try {
      await _remote.startMatch(
        competitionId: competitionId,
        matchId: matchId,
        streamUrl: streamUrl,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMatchScores({
    required String competitionId,
    required String matchId,
    required int homeScore,
    required int awayScore,
  }) async {
    try {
      await _remote.updateMatchScores(
        competitionId: competitionId,
        matchId: matchId,
        homeScore: homeScore,
        awayScore: awayScore,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addMatchEvent({
    required String competitionId,
    required String matchId,
    required ManageMatchEventKind kind,
    required String playerName,
    required String minuteLabel,
    required String title,
    required String subtitle,
  }) async {
    try {
      final id = await _remote.addMatchEvent(
        competitionId: competitionId,
        matchId: matchId,
        kind: kind,
        playerName: playerName,
        minuteLabel: minuteLabel,
        title: title,
        subtitle: subtitle,
      );
      return Right(id);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> endMatch({
    required String competitionId,
    required String matchId,
    required int homeScore,
    required int awayScore,
  }) async {
    try {
      await _remote.endMatch(
        competitionId: competitionId,
        matchId: matchId,
        homeScore: homeScore,
        awayScore: awayScore,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateMatchSchedule({
    required String competitionId,
    required String matchId,
    required DateTime kickoffAt,
  }) async {
    try {
      await _remote.updateMatchSchedule(
        competitionId: competitionId,
        matchId: matchId,
        kickoffAt: kickoffAt,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> endLeague({
    required String competitionId,
    required String winnerDisplayName,
  }) async {
    try {
      await _remote.endLeague(
        competitionId: competitionId,
        winnerDisplayName: winnerDisplayName,
      );
      return const Right(unit);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ManageMatchEventEntity>>> getMatchEvents({
    required String competitionId,
    required String matchId,
    required int limit,
  }) async {
    try {
      final events = await _remote.getMatchEvents(
        competitionId: competitionId,
        matchId: matchId,
        limit: limit,
      );
      return Right(events);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

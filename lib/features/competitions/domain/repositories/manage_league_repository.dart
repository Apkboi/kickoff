import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/stream_link.dart';
import '../entities/manage_league_dashboard_entity.dart';
import '../entities/manage_league_snapshot_entity.dart';
import '../entities/league_fixture_summary_entity.dart';
import '../entities/manage_match_event_entity.dart';

abstract class ManageLeagueRepository {
  Future<Either<Failure, ManageLeagueDashboardEntity>> getDashboard(String competitionId);

  Future<Either<Failure, ManageLeagueSnapshotEntity>> getAdminMatchSnapshot({
    required String competitionId,
    required String leagueName,
    required String matchId,
    required List<LeagueFixtureSummaryEntity> fixtures,
    required Set<String> startedMatchIds,
  });

  Future<Either<Failure, Unit>> startMatch({
    required String competitionId,
    required String matchId,
    List<StreamLink> streamLinks = const [],
  });

  Future<Either<Failure, Unit>> updateMatchScores({
    required String competitionId,
    required String matchId,
    required int homeScore,
    required int awayScore,
  });

  Future<Either<Failure, String>> addMatchEvent({
    required String competitionId,
    required String matchId,
    required ManageMatchEventKind kind,
    required String playerName,
    required String minuteLabel,
    required String title,
    required String subtitle,
  });

  Future<Either<Failure, Unit>> endMatch({
    required String competitionId,
    required String matchId,
    required int homeScore,
    required int awayScore,
  });

  Future<Either<Failure, Unit>> updateMatchSchedule({
    required String competitionId,
    required String matchId,
    required DateTime kickoffAt,
  });

  Future<Either<Failure, Unit>> endLeague({
    required String competitionId,
    required String winnerDisplayName,
  });

  Future<Either<Failure, List<ManageMatchEventEntity>>> getMatchEvents({
    required String competitionId,
    required String matchId,
    required int limit,
  });
}

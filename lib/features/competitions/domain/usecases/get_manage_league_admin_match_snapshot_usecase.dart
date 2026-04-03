import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/league_fixture_summary_entity.dart';
import '../entities/manage_league_snapshot_entity.dart';
import '../repositories/manage_league_repository.dart';

class GetManageLeagueAdminMatchSnapshotParams extends Equatable {
  const GetManageLeagueAdminMatchSnapshotParams({
    required this.competitionId,
    required this.leagueName,
    required this.matchId,
    required this.fixtures,
    required this.startedMatchIds,
  });

  final String competitionId;
  final String leagueName;
  final String matchId;
  final List<LeagueFixtureSummaryEntity> fixtures;
  final Set<String> startedMatchIds;

  @override
  List<Object?> get props => [competitionId, leagueName, matchId, fixtures, startedMatchIds];
}

class GetManageLeagueAdminMatchSnapshotUseCase {
  const GetManageLeagueAdminMatchSnapshotUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, ManageLeagueSnapshotEntity>> call(GetManageLeagueAdminMatchSnapshotParams params) {
    return _repository.getAdminMatchSnapshot(
      competitionId: params.competitionId,
      leagueName: params.leagueName,
      matchId: params.matchId,
      fixtures: params.fixtures,
      startedMatchIds: params.startedMatchIds,
    );
  }
}

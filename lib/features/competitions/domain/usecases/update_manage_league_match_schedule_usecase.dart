import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/manage_league_repository.dart';

class UpdateManageLeagueMatchScheduleParams extends Equatable {
  const UpdateManageLeagueMatchScheduleParams({
    required this.competitionId,
    required this.matchId,
    required this.kickoffAt,
  });

  final String competitionId;
  final String matchId;
  final DateTime kickoffAt;

  @override
  List<Object?> get props => [competitionId, matchId, kickoffAt];
}

class UpdateManageLeagueMatchScheduleUseCase {
  const UpdateManageLeagueMatchScheduleUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, Unit>> call(UpdateManageLeagueMatchScheduleParams params) {
    return _repository.updateMatchSchedule(
      competitionId: params.competitionId,
      matchId: params.matchId,
      kickoffAt: params.kickoffAt,
    );
  }
}


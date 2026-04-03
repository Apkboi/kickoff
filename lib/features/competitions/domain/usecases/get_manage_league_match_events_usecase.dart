import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/manage_match_event_entity.dart';
import '../repositories/manage_league_repository.dart';

class GetManageLeagueMatchEventsParams extends Equatable {
  const GetManageLeagueMatchEventsParams({
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

class GetManageLeagueMatchEventsUseCase {
  const GetManageLeagueMatchEventsUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, List<ManageMatchEventEntity>>> call(
    GetManageLeagueMatchEventsParams params,
  ) {
    return _repository.getMatchEvents(
      competitionId: params.competitionId,
      matchId: params.matchId,
      limit: params.limit,
    );
  }
}


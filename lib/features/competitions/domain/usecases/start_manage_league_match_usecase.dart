import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/stream_link.dart';
import '../repositories/manage_league_repository.dart';

class StartManageLeagueMatchParams extends Equatable {
  const StartManageLeagueMatchParams({
    required this.competitionId,
    required this.matchId,
    this.streamLinks = const [],
  });

  final String competitionId;
  final String matchId;
  final List<StreamLink> streamLinks;

  @override
  List<Object?> get props => [competitionId, matchId, streamLinks];
}

class StartManageLeagueMatchUseCase {
  const StartManageLeagueMatchUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, Unit>> call(StartManageLeagueMatchParams params) {
    return _repository.startMatch(
      competitionId: params.competitionId,
      matchId: params.matchId,
      streamLinks: params.streamLinks,
    );
  }
}


import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../repositories/manage_league_repository.dart';

class AddManageLeagueMatchEventParams extends Equatable {
  const AddManageLeagueMatchEventParams({
    required this.competitionId,
    required this.matchId,
    required this.kind,
    required this.playerName,
    required this.minuteLabel,
    required this.title,
    required this.subtitle,
  });

  final String competitionId;
  final String matchId;
  final ManageMatchEventKind kind;
  final String playerName;
  final String minuteLabel;
  final String title;
  final String subtitle;

  @override
  List<Object?> get props => [
        competitionId,
        matchId,
        kind,
        playerName,
        minuteLabel,
        title,
        subtitle,
      ];
}

class AddManageLeagueMatchEventUseCase {
  const AddManageLeagueMatchEventUseCase(this._repository);

  final ManageLeagueRepository _repository;

  Future<Either<Failure, String>> call(AddManageLeagueMatchEventParams params) {
    return _repository.addMatchEvent(
      competitionId: params.competitionId,
      matchId: params.matchId,
      kind: params.kind,
      playerName: params.playerName,
      minuteLabel: params.minuteLabel,
      title: params.title,
      subtitle: params.subtitle,
    );
  }
}


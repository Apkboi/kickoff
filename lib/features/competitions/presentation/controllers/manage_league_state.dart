import 'package:equatable/equatable.dart';

import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/entities/manage_league_snapshot_entity.dart';

abstract class ManageLeagueState extends Equatable {
  const ManageLeagueState();

  @override
  List<Object?> get props => [];
}

class ManageLeagueInitial extends ManageLeagueState {
  const ManageLeagueInitial();
}

class ManageLeagueLoading extends ManageLeagueState {
  const ManageLeagueLoading();
}

class ManageLeagueAccessDenied extends ManageLeagueState {
  const ManageLeagueAccessDenied();
}

class ManageLeagueLoaded extends ManageLeagueState {
  const ManageLeagueLoaded({
    required this.fixtures,
    required this.selectedMatchId,
    required this.startedMatchIds,
    required this.snapshot,
    required this.isLiveUpdateMode,
    this.isEventsLoading = false,
  });

  final List<LeagueFixtureSummaryEntity> fixtures;
  final String selectedMatchId;
  final Set<String> startedMatchIds;
  final ManageLeagueSnapshotEntity snapshot;
  final bool isLiveUpdateMode;
  final bool isEventsLoading;

  @override
  List<Object?> get props => [
        fixtures,
        selectedMatchId,
        startedMatchIds,
        snapshot,
        isLiveUpdateMode,
        isEventsLoading,
      ];
}

class ManageLeagueError extends ManageLeagueState {
  const ManageLeagueError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

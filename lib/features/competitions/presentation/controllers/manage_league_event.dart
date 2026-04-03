import 'package:equatable/equatable.dart';

import '../../../../core/models/stream_link.dart';
import '../../domain/entities/manage_match_event_entity.dart';

abstract class ManageLeagueEvent extends Equatable {
  const ManageLeagueEvent();

  @override
  List<Object?> get props => [];
}

class ManageLeagueStarted extends ManageLeagueEvent {
  const ManageLeagueStarted(this.competitionId);

  final String competitionId;

  @override
  List<Object?> get props => [competitionId];
}

/// Select a fixture to administer (scores / events). Does not navigate away.
class ManageLeagueMatchSelected extends ManageLeagueEvent {
  const ManageLeagueMatchSelected(this.matchId);

  final String matchId;

  @override
  List<Object?> get props => [matchId];
}

/// Kick off a scheduled fixture so scoring controls unlock.
class ManageLeagueMatchStarted extends ManageLeagueEvent {
  const ManageLeagueMatchStarted(this.matchId, {this.streamLinks = const []});

  final String matchId;
  final List<StreamLink> streamLinks;

  @override
  List<Object?> get props => [matchId, streamLinks];
}

/// Marks a live match as finished, persists final score, and triggers standings update.
class ManageLeagueMatchEnded extends ManageLeagueEvent {
  const ManageLeagueMatchEnded(this.matchId);

  final String matchId;

  @override
  List<Object?> get props => [matchId];
}

class ManageLeagueScheduleUpdated extends ManageLeagueEvent {
  const ManageLeagueScheduleUpdated({
    required this.matchId,
    required this.kickoffAt,
  });

  final String matchId;
  final DateTime kickoffAt;

  @override
  List<Object?> get props => [matchId, kickoffAt];
}

/// Admin ends the whole competition and records a winner.
class ManageLeagueCompetitionEnded extends ManageLeagueEvent {
  const ManageLeagueCompetitionEnded(this.winnerDisplayName);

  final String winnerDisplayName;

  @override
  List<Object?> get props => [winnerDisplayName];
}

class ManageLeagueHomeScoreDelta extends ManageLeagueEvent {
  const ManageLeagueHomeScoreDelta(this.delta, {this.scorerName});

  final int delta;
  final String? scorerName;

  @override
  List<Object?> get props => [delta, scorerName];
}

class ManageLeagueAwayScoreDelta extends ManageLeagueEvent {
  const ManageLeagueAwayScoreDelta(this.delta, {this.scorerName});

  final int delta;
  final String? scorerName;

  @override
  List<Object?> get props => [delta, scorerName];
}

class ManageLeagueLiveModeToggled extends ManageLeagueEvent {
  const ManageLeagueLiveModeToggled(this.isLiveUpdate);

  final bool isLiveUpdate;

  @override
  List<Object?> get props => [isLiveUpdate];
}

class ManageLeagueQuickEventAdded extends ManageLeagueEvent {
  const ManageLeagueQuickEventAdded(this.kind, {this.playerName});

  final ManageMatchEventKind kind;
  final String? playerName;

  @override
  List<Object?> get props => [kind, playerName];
}

class ManageLeagueEventDeleted extends ManageLeagueEvent {
  const ManageLeagueEventDeleted(this.eventId);

  final String eventId;

  @override
  List<Object?> get props => [eventId];
}

import 'package:equatable/equatable.dart';

abstract class MatchDetailEvent extends Equatable {
  const MatchDetailEvent();

  @override
  List<Object?> get props => [];
}

class MatchDetailWatchStarted extends MatchDetailEvent {
  const MatchDetailWatchStarted({
    required this.competitionId,
    required this.matchId,
  });

  final String competitionId;
  final String matchId;

  @override
  List<Object?> get props => [competitionId, matchId];
}

import 'package:equatable/equatable.dart';

abstract class LeagueFixturesPaginationEvent extends Equatable {
  const LeagueFixturesPaginationEvent();

  @override
  List<Object?> get props => [];
}

class LeagueFixturesPaginationStarted extends LeagueFixturesPaginationEvent {
  const LeagueFixturesPaginationStarted({
    required this.competitionId,
    required this.pageSize,
  });

  final String competitionId;
  final int pageSize;

  @override
  List<Object?> get props => [competitionId, pageSize];
}

class LeagueFixturesPaginationNextRequested extends LeagueFixturesPaginationEvent {
  const LeagueFixturesPaginationNextRequested();
}


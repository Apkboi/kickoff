import 'package:equatable/equatable.dart';

enum LeagueFixturePhase { scheduled, live, finished }

class LeagueFixtureSummaryEntity extends Equatable {
  const LeagueFixtureSummaryEntity({
    required this.matchId,
    required this.headline,
    required this.statusLine,
    required this.phase,
    required this.matchWeek,
    required this.kickoffAt,
    required this.homeScore,
    required this.awayScore,
    this.homeId,
    this.awayId,
  });

  final String matchId;
  final String headline;
  final String statusLine;
  final LeagueFixturePhase phase;
  final int matchWeek;
  final DateTime? kickoffAt;
  final int homeScore;
  final int awayScore;
  final String? homeId;
  final String? awayId;

  LeagueFixtureSummaryEntity copyWith({
    LeagueFixturePhase? phase,
    int? homeScore,
    int? awayScore,
    String? statusLine,
    int? matchWeek,
    DateTime? kickoffAt,
    String? headline,
  }) {
    return LeagueFixtureSummaryEntity(
      matchId: matchId,
      headline: headline ?? this.headline,
      statusLine: statusLine ?? this.statusLine,
      phase: phase ?? this.phase,
      matchWeek: matchWeek ?? this.matchWeek,
      kickoffAt: kickoffAt ?? this.kickoffAt,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      homeId: homeId,
      awayId: awayId,
    );
  }

  @override
  List<Object?> get props =>
      [matchId, headline, statusLine, phase, matchWeek, kickoffAt, homeScore, awayScore, homeId, awayId];
}

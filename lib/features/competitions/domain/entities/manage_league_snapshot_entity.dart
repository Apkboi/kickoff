import 'package:equatable/equatable.dart';

import 'manage_match_event_entity.dart';

class ManageLeagueSnapshotEntity extends Equatable {
  const ManageLeagueSnapshotEntity({
    required this.competitionId,
    required this.leagueName,
    required this.matchTitle,
    required this.matchdayClockLabel,
    required this.isLive,
    required this.homeTeamName,
    required this.homeTeamShort,
    required this.awayTeamName,
    required this.awayTeamShort,
    required this.homeScore,
    required this.awayScore,
    required this.matchClock,
    required this.events,
    required this.scoringEnabled,
    this.homePhotoUrl,
    this.awayPhotoUrl,
  });

  final String competitionId;
  final String leagueName;
  final String matchTitle;
  final String matchdayClockLabel;
  final bool isLive;
  final String homeTeamName;
  final String homeTeamShort;
  final String awayTeamName;
  final String awayTeamShort;
  final int homeScore;
  final int awayScore;
  final String matchClock;
  final List<ManageMatchEventEntity> events;
  /// Admin can adjust scores / events only when true (live match or started kickoff).
  final bool scoringEnabled;
  final String? homePhotoUrl;
  final String? awayPhotoUrl;

  ManageLeagueSnapshotEntity copyWith({
    String? competitionId,
    String? leagueName,
    String? matchTitle,
    String? matchdayClockLabel,
    bool? isLive,
    String? homeTeamName,
    String? homeTeamShort,
    String? awayTeamName,
    String? awayTeamShort,
    int? homeScore,
    int? awayScore,
    String? matchClock,
    List<ManageMatchEventEntity>? events,
    bool? scoringEnabled,
    String? homePhotoUrl,
    String? awayPhotoUrl,
  }) {
    return ManageLeagueSnapshotEntity(
      competitionId: competitionId ?? this.competitionId,
      leagueName: leagueName ?? this.leagueName,
      matchTitle: matchTitle ?? this.matchTitle,
      matchdayClockLabel: matchdayClockLabel ?? this.matchdayClockLabel,
      isLive: isLive ?? this.isLive,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      homeTeamShort: homeTeamShort ?? this.homeTeamShort,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      awayTeamShort: awayTeamShort ?? this.awayTeamShort,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      matchClock: matchClock ?? this.matchClock,
      events: events ?? this.events,
      scoringEnabled: scoringEnabled ?? this.scoringEnabled,
      homePhotoUrl: homePhotoUrl ?? this.homePhotoUrl,
      awayPhotoUrl: awayPhotoUrl ?? this.awayPhotoUrl,
    );
  }

  @override
  List<Object?> get props => [
        competitionId,
        leagueName,
        matchTitle,
        matchdayClockLabel,
        isLive,
        homeTeamName,
        homeTeamShort,
        awayTeamName,
        awayTeamShort,
        homeScore,
        awayScore,
        matchClock,
        events,
        scoringEnabled,
        homePhotoUrl,
        awayPhotoUrl,
      ];
}

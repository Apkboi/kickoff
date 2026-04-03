import 'package:equatable/equatable.dart';

class HomeLiveMatchEntity extends Equatable {
  const HomeLiveMatchEntity({
    required this.leagueId,
    required this.leagueName,
    this.leagueBannerUrl,
    required this.matchId,
    required this.homeName,
    required this.awayName,
    required this.homeScore,
    required this.awayScore,
    required this.elapsedMinute,
    required this.progress,
  });

  final String leagueId;
  final String leagueName;
  final String? leagueBannerUrl;
  final String matchId;
  final String homeName;
  final String awayName;
  final int homeScore;
  final int awayScore;
  final int elapsedMinute;
  final double progress;

  @override
  List<Object?> get props => [
        leagueId,
        leagueName,
        leagueBannerUrl,
        matchId,
        homeName,
        awayName,
        homeScore,
        awayScore,
        elapsedMinute,
        progress,
      ];
}

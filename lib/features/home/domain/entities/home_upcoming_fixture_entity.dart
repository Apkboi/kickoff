import 'package:equatable/equatable.dart';

class HomeUpcomingFixtureEntity extends Equatable {
  const HomeUpcomingFixtureEntity({
    required this.leagueId,
    required this.leagueName,
    this.leagueBannerUrl,
    required this.matchId,
    required this.homeName,
    required this.awayName,
    required this.kickoffAt,
  });

  final String leagueId;
  final String leagueName;
  final String? leagueBannerUrl;
  final String matchId;
  final String homeName;
  final String awayName;
  final DateTime kickoffAt;

  @override
  List<Object?> get props => [leagueId, leagueName, leagueBannerUrl, matchId, homeName, awayName, kickoffAt];
}

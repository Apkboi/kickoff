import 'package:equatable/equatable.dart';

import 'league_admin_entity.dart';
import 'league_fixture_summary_entity.dart';
import 'standing_row_entity.dart';

class LeagueDetailEntity extends Equatable {
  const LeagueDetailEntity({
    required this.id,
    required this.name,
    required this.seasonLabel,
    required this.isLive,
    required this.teamCount,
    required this.currentWeek,
    required this.totalWeeks,
    required this.standings,
    required this.admins,
    required this.adminUserIds,
    required this.matchOfWeekHome,
    required this.matchOfWeekAway,
    required this.matchOfWeekTimeLabel,
    required this.matchOfWeekBadgeLabel,
    required this.fixtures,
    this.logoUrl,
    this.bannerUrl,
  });

  final String id;
  final String name;
  final String seasonLabel;
  final bool isLive;
  final int teamCount;
  final int currentWeek;
  final int totalWeeks;
  final List<StandingRowEntity> standings;
  final List<LeagueAdminEntity> admins;
  /// Firebase UIDs (or `*` in mock data = any signed-in user may manage).
  final List<String> adminUserIds;
  final String matchOfWeekHome;
  final String matchOfWeekAway;
  final String matchOfWeekTimeLabel;
  final String matchOfWeekBadgeLabel;
  final List<LeagueFixtureSummaryEntity> fixtures;
  final String? logoUrl;
  final String? bannerUrl;

  String get weekSubtitle => 'Week $currentWeek of $totalWeeks';

  @override
  List<Object?> get props => [
        id,
        name,
        seasonLabel,
        isLive,
        teamCount,
        currentWeek,
        totalWeeks,
        standings,
        admins,
        adminUserIds,
        matchOfWeekHome,
        matchOfWeekAway,
        matchOfWeekTimeLabel,
        matchOfWeekBadgeLabel,
        fixtures,
        logoUrl,
        bannerUrl,
      ];
}

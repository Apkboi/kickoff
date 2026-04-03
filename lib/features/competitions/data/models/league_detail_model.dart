import '../../domain/entities/league_detail_entity.dart';

class LeagueDetailModel extends LeagueDetailEntity {
  const LeagueDetailModel({
    required super.id,
    required super.name,
    required super.seasonLabel,
    required super.isLive,
    required super.teamCount,
    required super.currentWeek,
    required super.totalWeeks,
    required super.standings,
    required super.admins,
    required super.adminUserIds,
    required super.matchOfWeekHome,
    required super.matchOfWeekAway,
    required super.matchOfWeekTimeLabel,
    required super.matchOfWeekBadgeLabel,
    required super.fixtures,
    super.logoUrl,
    super.bannerUrl,
    super.creatorUserId,
  });
}

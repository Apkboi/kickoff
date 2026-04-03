import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../shared/widgets/stream_link_launch_sheet.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import '../utils/home_fixture_formatters.dart';
import 'home_dashboard_nav.dart';
import 'home_hero_match_card.dart';

class HomeDashboardHero extends StatelessWidget {
  const HomeDashboardHero({
    required this.liveMatches,
    required this.upcomingMatches,
    required this.compact,
    super.key,
  });

  final List<HomeLiveMatchEntity> liveMatches;
  final List<HomeUpcomingFixtureEntity> upcomingMatches;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (liveMatches.isNotEmpty) {
      final m = liveMatches.first;
      return HomeHeroMatchCard(
        leagueChip: m.leagueName,
        contextLabel: m.leagueName,
        homeTeam: m.homeName.toUpperCase(),
        awayTeam: m.awayName.toUpperCase(),
        homeScore: m.homeScore,
        awayScore: m.awayScore,
        isLive: true,
        bannerImageUrl: m.leagueBannerUrl,
        compact: compact,
        onTap: () async {
          if (m.streamLinks.isNotEmpty) {
            await launchStreamLinksOrSheet(context, m.streamLinks);
          } else {
            HomeDashboardNav.openMatch(context, m.leagueId, m.matchId);
          }
        },
      );
    }
    if (upcomingMatches.isNotEmpty) {
      final u = upcomingMatches.first;
      final k = u.kickoffAt;
      final label = HomeFixtureFormatters.kickoffFull(k);
      return HomeHeroMatchCard(
        leagueChip: u.leagueName,
        contextLabel: u.leagueName,
        homeTeam: u.homeName.toUpperCase(),
        awayTeam: u.awayName.toUpperCase(),
        homeScore: 0,
        awayScore: 0,
        isLive: false,
        kickoffLabel: label,
        bannerImageUrl: u.leagueBannerUrl,
        compact: compact,
        onTap: () => HomeDashboardNav.openMatch(context, u.leagueId, u.matchId),
      );
    }
    return HomeHeroMatchCard(
      leagueChip: 'KickOff',
      contextLabel: '',
      homeTeam: 'YOUR LEAGUE',
      awayTeam: 'RIVAL',
      homeScore: 0,
      awayScore: 0,
      isLive: false,
      kickoffLabel: 'Create or join a league',
      compact: compact,
      onTap: () => context.push(AppRoutes.createLeague),
    );
  }
}

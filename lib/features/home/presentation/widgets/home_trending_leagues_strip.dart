import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/home_trending_league_entity.dart';

class HomeTrendingLeaguesStrip extends StatelessWidget {
  const HomeTrendingLeaguesStrip({
    required this.leagues,
    required this.onLeagueTap,
    super.key,
  });

  final List<HomeTrendingLeagueEntity> leagues;
  final void Function(String leagueId) onLeagueTap;

  static const _accentColors = [
    DashboardColors.accentGreen,
    DashboardColors.rankGold,
    DashboardColors.accentAmber,
    DashboardColors.accentMuted,
  ];

  @override
  Widget build(BuildContext context) {
    if (leagues.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: DashboardColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: DashboardColors.borderSubtle),
        ),
        child: const Text(
          'No published leagues yet.',
          style: TextStyle(color: DashboardColors.textSecondary, fontSize: 13),
        ),
      );
    }
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < leagues.length && i < 4; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _TrendingStripCard(
                league: leagues[i],
                color: _accentColors[i % _accentColors.length],
                onTap: () => onLeagueTap(leagues[i].id),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrendingStripCard extends StatelessWidget {
  const _TrendingStripCard({
    required this.league,
    required this.color,
    required this.onTap,
  });

  final HomeTrendingLeagueEntity league;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.trending_up, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                league.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: DashboardColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              Text(
                league.subtitle,
                style: const TextStyle(
                  color: DashboardColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

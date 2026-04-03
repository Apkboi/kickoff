import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_detail_entity.dart';

class LeagueDetailHero extends StatelessWidget {
  const LeagueDetailHero({
    required this.detail,
    this.compact = true,
    super.key,
  });

  final LeagueDetailEntity detail;
  /// Narrow/mobile-style banner height vs taller desktop hero.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            height: compact ? 200 : 280,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  DashboardColors.bgSurface,
                  DashboardColors.bgPrimary,
                ],
              ),
            ),
            child: detail.bannerUrl != null && detail.bannerUrl!.isNotEmpty
                ? Image.network(
                    detail.bannerUrl!,
                    fit: BoxFit.cover,
                    height: compact ? 200 : 280,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Image.asset(
                      AppAssets.gamingHeroPlaceholder,
                      fit: BoxFit.cover,
                      height: compact ? 200 : 280,
                      width: double.infinity,
                    ),
                  )
                : Image.asset(
                    AppAssets.gamingHeroPlaceholder,
                    fit: BoxFit.cover,
                    height: compact ? 200 : 280,
                    width: double.infinity,
                  ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (detail.isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: DashboardColors.accentGreen.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: DashboardColors.accentGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'LIVE',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: DashboardColors.accentNeon,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    if (detail.isLive) const SizedBox(width: AppSpacing.sm),
                    Text(
                      detail.seasonLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: DashboardColors.textSecondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  detail.name,
                  style: (compact
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.headlineMedium)
                      ?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.groups_outlined, size: 18, color: DashboardColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${detail.teamCount} Teams',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    const Icon(Icons.calendar_month_outlined, size: 18, color: DashboardColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      detail.weekSubtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

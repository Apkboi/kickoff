import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileSportStatCard extends StatelessWidget {
  const ProfileSportStatCard({required this.section, super.key});

  final ProfileSportSection section;

  @override
  Widget build(BuildContext context) {
    final rankColor = section.rankBadgeGold ? DashboardColors.rankGold : DashboardColors.accentGreen;
    final subtle = BorderSide(color: DashboardColors.borderSubtle);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: DashboardColors.bgCard,
        // borderRadius: BorderRadius.circular(AppRadius.card),
        border: section.isPrimary
            ? Border.all(color: DashboardColors.borderSubtle)
            : Border(
                left: const BorderSide(color: DashboardColors.accentAmber, width: 4),
                top: subtle,
                right: subtle,
                bottom: subtle,
              ),
      ),
      child: Stack(
        children: [
          if (section.isPrimary)
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                Icons.sports_soccer,
                size: 140,
                color: DashboardColors.textPrimary.withValues(alpha: 0.04),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: section.isPrimary
                            ? DashboardColors.accentGreen.withValues(alpha: 0.15)
                            : DashboardColors.accentAmber.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.button),
                      ),
                      child: Icon(
                        section.sportName == 'Soccer' ? Icons.sports_soccer : Icons.sports_basketball,
                        color: section.isPrimary ? DashboardColors.accentGreen : DashboardColors.accentAmber,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.sportName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: DashboardColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          Text(
                            section.roleLabel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: rankColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        section.rankBadge,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: rankColor,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 2.4,
                  children: section.stats.map((s) => _StatCell(item: s)).toList(),
                ),
                if (section.showViewAnalytics) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'VIEW DETAILED ANALYTICS ›',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: DashboardColors.accentGreen,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.item});

  final ProfileStatItem item;

  Color _valueColor() {
    if (item.goldValue) return DashboardColors.rankGold;
    if (item.emphasizeValue) return DashboardColors.accentGreen;
    return DashboardColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: _valueColor(),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (item.progress != null) ...[
          Text(item.value, style: valueStyle),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: item.progress!.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: DashboardColors.bgSurface,
              color: DashboardColors.accentGreen,
            ),
          ),
        ] else
          Row(
            children: [
              if (item.goldValue) const Icon(Icons.star, size: 16, color: DashboardColors.rankGold),
              if (item.goldValue) const SizedBox(width: AppSpacing.xs),
              Text(item.value, style: valueStyle),
            ],
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_card_status.dart';

class LeagueCardStatusBadge extends StatelessWidget {
  const LeagueCardStatusBadge({required this.status, super.key});

  final LeagueCardStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case LeagueCardStatus.live:
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: DashboardColors.accentGreen.withValues(alpha: 0.2),
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
                  'LIVE NOW',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DashboardColors.accentNeon,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        );
      case LeagueCardStatus.upcoming:
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: DashboardColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(color: DashboardColors.borderSubtle),
            ),
            child: Text(
              'STARTS IN 2H',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: DashboardColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );
      case LeagueCardStatus.private:
        return const SizedBox.shrink();
    }
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ProfileXpBar extends StatelessWidget {
  const ProfileXpBar({
    required this.level,
    required this.xpCurrent,
    required this.xpToNext,
    required this.progress,
    super.key,
  });

  final int level;
  final int xpCurrent;
  final int xpToNext;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LEVEL $level',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: DashboardColors.accentGreen,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            Text(
              '$xpCurrent / $xpToNext XP',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: DashboardColors.bgSurface,
            color: DashboardColors.accentGreen,
          ),
        ),
      ],
    );
  }
}

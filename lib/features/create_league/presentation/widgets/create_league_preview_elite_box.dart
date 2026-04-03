import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class CreateLeaguePreviewEliteBox extends StatelessWidget {
  const CreateLeaguePreviewEliteBox({required this.participantTarget, super.key});

  final int participantTarget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: DashboardColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user, color: DashboardColors.accentGreen, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elite Visibility',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Leagues with $participantTarget+ participants can be featured globally.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DashboardColors.textSecondary,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

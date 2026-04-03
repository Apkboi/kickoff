import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/match_prediction_view_entity.dart';

/// Read-only summary of the signed-in user's saved score pick.
class MatchPredictionYourPickCard extends StatelessWidget {
  const MatchPredictionYourPickCard({required this.prediction, super.key});

  final UserPredictionEntity prediction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: DashboardColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Row(
        children: [
          const Icon(Icons.sports_soccer, color: DashboardColors.accentGreen, size: 22),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your prediction',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DashboardColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${prediction.homePredicted} — ${prediction.awayPredicted}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: DashboardColors.textPrimary,
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

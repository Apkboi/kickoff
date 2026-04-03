import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ProfileSummaryStatsRow extends StatelessWidget {
  const ProfileSummaryStatsRow({
    required this.matches,
    required this.wins,
    required this.leagues,
    super.key,
  });

  final int matches;
  final int wins;
  final int leagues;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatBox(label: 'MATCHES', value: '$matches', highlight: false)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatBox(label: 'WINS', value: '$wins', highlight: true)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: _StatBox(label: 'TOURNAMENTS', value: '$leagues', highlight: false)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.highlight,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: DashboardColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: highlight ? DashboardColors.accentGreen : DashboardColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: DashboardColors.textSecondary,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

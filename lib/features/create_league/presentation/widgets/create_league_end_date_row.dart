import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class CreateLeagueEndDateRow extends StatelessWidget {
  const CreateLeagueEndDateRow({
    required this.displayText,
    required this.onSetPressed,
    required this.showClear,
    required this.onClearPressed,
    super.key,
  });

  final String displayText;
  final VoidCallback onSetPressed;
  final bool showClear;
  final VoidCallback onClearPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: DashboardColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.button),
              border: Border.all(color: DashboardColors.borderSubtle),
            ),
            child: Text(
              displayText,
              style: const TextStyle(color: DashboardColors.textPrimary),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        OutlinedButton(
          onPressed: onSetPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: DashboardColors.accentGreen,
            side: const BorderSide(color: DashboardColors.accentGreen),
          ),
          child: const Text('Set'),
        ),
        if (showClear) ...[
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: onClearPressed,
            icon: const Icon(Icons.clear, color: DashboardColors.textSecondary),
            tooltip: 'Clear',
          ),
        ],
      ],
    );
  }
}

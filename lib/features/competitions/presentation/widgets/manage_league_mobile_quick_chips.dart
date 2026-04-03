import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ManageLeagueMobileQuickChips extends StatelessWidget {
  const ManageLeagueMobileQuickChips({
    required this.onCard,
    required this.onRedCard,
    super.key,
  });

  final VoidCallback onCard;
  final VoidCallback onRedCard;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickChip(
          icon: Icons.style,
          label: 'YELLOW',
          color: DashboardColors.rankGold,
          onTap: onCard,
        ),
        const SizedBox(width: AppSpacing.sm),
        _QuickChip(
          icon: Icons.cancel,
          label: 'RED',
          color: DashboardColors.liveBadge,
          onTap: onRedCard,
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: DashboardColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: DashboardColors.textSecondary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ManageLeagueLiveFinalToggle extends StatelessWidget {
  const ManageLeagueLiveFinalToggle({
    required this.isLiveUpdate,
    required this.onChanged,
    super.key,
  });

  final bool isLiveUpdate;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DashboardColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSide(
              label: 'Live Update',
              selected: isLiveUpdate,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _ToggleSide(
              label: 'Final Result',
              selected: !isLiveUpdate,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleSide extends StatelessWidget {
  const _ToggleSide({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? DashboardColors.accentGreen.withValues(alpha: 0.25) : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: selected ? DashboardColors.accentNeon : DashboardColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

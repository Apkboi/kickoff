import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class CreateLeagueAutomationRow extends StatelessWidget {
  const CreateLeagueAutomationRow({
    required this.showToggle,
    this.value,
    this.onChanged,
    super.key,
  });

  /// When false, shows informational copy only (e.g. mobile).
  final bool showToggle;
  final bool? value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: DashboardColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bolt, color: DashboardColors.accentGreen),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showToggle ? 'Automate Fixtures' : 'Automated fixtures',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  showToggle
                      ? 'We schedule rounds and notify teams automatically.'
                      : 'Fixtures are generated and scheduled automatically for this league. '
                          'You will be able to review rounds before they go live.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DashboardColors.textSecondary,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
          if (showToggle && value != null && onChanged != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Switch(
              value: value!,
              activeThumbColor: Colors.black,
              activeTrackColor: DashboardColors.accentGreen,
              onChanged: onChanged,
            ),
          ],
        ],
      ),
    );
  }
}

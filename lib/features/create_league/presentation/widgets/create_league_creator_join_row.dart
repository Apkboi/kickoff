import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

/// Lets the organizer choose whether they appear in fixtures/standings or only manage the league.
class CreateLeagueCreatorJoinRow extends StatelessWidget {
  const CreateLeagueCreatorJoinRow({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      title: Text(
        'Join as a participant',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: DashboardColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xs),
        child: Text(
          'Off: you organize only (no matches for you). Match results are updated in Manage league by admins.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: DashboardColors.textSecondary,
              ),
        ),
      ),
      activeThumbColor: DashboardColors.accentGreen,
    );
  }
}

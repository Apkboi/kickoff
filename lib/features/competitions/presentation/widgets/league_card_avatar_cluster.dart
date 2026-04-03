import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class LeagueCardAvatarCluster extends StatelessWidget {
  const LeagueCardAvatarCluster({required this.showMe, super.key});

  final bool showMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Align(
            widthFactor: i == 0 ? 1 : 0.65,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: DashboardColors.bgSurface,
              child: Text('${i + 1}', style: const TextStyle(fontSize: 10)),
            ),
          ),
        if (showMe)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
              decoration: BoxDecoration(
                color: DashboardColors.accentGreen.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                'ME',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: DashboardColors.accentNeon,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
      ],
    );
  }
}

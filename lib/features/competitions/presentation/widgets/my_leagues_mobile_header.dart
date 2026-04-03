import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class MyLeaguesMobileHeader extends StatelessWidget {
  const MyLeaguesMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: DashboardColors.bgSurface,
            child: const Icon(Icons.person, color: DashboardColors.textSecondary),
          ),
          Expanded(
            child: Text(
              'KickOff',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: DashboardColors.accentGreen,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: DashboardColors.accentGreen),
          ),
        ],
      ),
    );
  }
}

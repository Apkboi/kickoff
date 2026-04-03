import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ProfileDesktopTopBar extends StatelessWidget {
  const ProfileDesktopTopBar({
    required this.streakDays,
    super.key,
  });

  final int streakDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search leagues, teams, or players...',
              hintStyle: TextStyle(color: DashboardColors.textSecondary.withValues(alpha: 0.8)),
              filled: true,
              fillColor: DashboardColors.bgSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              prefixIcon: const Icon(Icons.search, color: DashboardColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: DashboardColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department, color: DashboardColors.accentGreen, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '$streakDays DAY STREAK',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: DashboardColors.accentGreen,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_outlined, color: DashboardColors.textSecondary),
        ),
        const CircleAvatar(
          radius: 20,
          backgroundColor: DashboardColors.bgSurface,
          child: Icon(Icons.person, color: DashboardColors.textSecondary),
        ),
      ],
    );
  }
}

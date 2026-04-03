import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileAchievementBanner extends StatelessWidget {
  const ProfileAchievementBanner({required this.achievement, super.key});

  final ProfileAchievement achievement;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 520;
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: DashboardColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
            ),
          ],
        );
        final icon = Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: DashboardColors.accentGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          child: const Icon(Icons.emoji_events_outlined, color: DashboardColors.accentGreen, size: 28),
        );
        final button = FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: DashboardColors.accentGreen,
            foregroundColor: DashboardColors.textOnAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
          ),
          child: const Text('Claim Badge'),
        );
        if (narrow) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: DashboardColors.bgCard,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: DashboardColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [icon, const SizedBox(width: AppSpacing.md), Expanded(child: content)]),
                const SizedBox(height: AppSpacing.md),
                button,
              ],
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon,
              const SizedBox(width: AppSpacing.md),
              Expanded(child: content),
              const SizedBox(width: AppSpacing.sm),
              button,
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_xp_bar.dart';

class ProfileUserColumn extends StatelessWidget {
  const ProfileUserColumn({required this.profile, super.key});

  final UserProfileEntity profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: DashboardColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [DashboardColors.accentGreen, DashboardColors.accentMuted],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: DashboardColors.bgSurface,
                    backgroundImage: profile.photoUrl != null && profile.photoUrl!.isNotEmpty
                        ? NetworkImage(profile.photoUrl!)
                        : null,
                    child: profile.photoUrl == null || profile.photoUrl!.isEmpty
                        ? const Icon(Icons.person, size: 48, color: DashboardColors.textSecondary)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: -4,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: DashboardColors.accentGreen,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        'LVL ${profile.level}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: DashboardColors.textOnAccent,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            profile.displayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: DashboardColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: DashboardColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                profile.locationLine,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ProfileXpBar(
            level: profile.level,
            xpCurrent: profile.xpCurrent,
            xpToNext: profile.xpToNext,
            progress: profile.xpProgress,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            profile.bio,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: DashboardColors.bgSurface,
              foregroundColor: DashboardColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
            ),
            child: const Text('Edit Profile'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {},
            child: Text(
              'Share Profile',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: DashboardColors.accentGreen),
            ),
          ),
        ],
      ),
    );
  }
}

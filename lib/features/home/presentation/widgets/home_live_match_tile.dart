import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/profile_avatar_chip.dart';

class HomeLiveMatchTile extends StatelessWidget {
  const HomeLiveMatchTile({
    required this.league,
    required this.home,
    required this.away,
    required this.homeScore,
    required this.awayScore,
    required this.progress,
    this.userPhotoUrl,
    this.onProfileTap,
    this.onTap,
    super.key,
  });

  final String league;
  final String home;
  final String away;
  final int homeScore;
  final int awayScore;
  final double progress;
  final String? userPhotoUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final inner = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.accentGreen.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: DashboardColors.accentGreen.withValues(alpha: 0.55),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      league,
                      style: const TextStyle(
                        color: DashboardColors.textSecondary,
                        fontSize: 10,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Text(
                    'LIVE',
                    style: TextStyle(
                      color: DashboardColors.accentNeon,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              _row(home, homeScore),
              const SizedBox(height: AppSpacing.xs),
              _row(away, awayScore),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: DashboardColors.bgSurface,
                  color: DashboardColors.accentGreen,
                ),
              ),
            ],
          ),
        ),
        if (onProfileTap != null)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: ProfileAvatarChip(
              photoUrl: userPhotoUrl,
              radius: 16,
              onTap: onProfileTap,
            ),
          ),
      ],
    );
    if (onTap == null) return inner;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: inner,
      ),
    );
  }

  Widget _row(String name, int score) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 8, color: DashboardColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: DashboardColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '$score',
          style: const TextStyle(
            color: DashboardColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

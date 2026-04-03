import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/profile_avatar_chip.dart';

class HomeUpcomingTileDesktop extends StatelessWidget {
  const HomeUpcomingTileDesktop({
    required this.dayLabel,
    required this.time,
    required this.title,
    required this.subtitle,
    this.userPhotoUrl,
    this.onProfileTap,
    this.onTap,
    super.key,
  });

  final String dayLabel;
  final String time;
  final String title;
  final String subtitle;
  final String? userPhotoUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final inner = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: DashboardColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                child: Column(
                  children: [
                    Text(
                      dayLabel,
                      style: const TextStyle(
                        color: DashboardColors.accentNeon,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 14, color: DashboardColors.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              color: DashboardColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
}

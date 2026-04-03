import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/profile_avatar_chip.dart';

class HomeUpcomingFixtureMobileTile extends StatelessWidget {
  const HomeUpcomingFixtureMobileTile({
    required this.leftCode,
    required this.rightCode,
    required this.time,
    required this.day,
    required this.leagueLine,
    this.userPhotoUrl,
    this.onProfileTap,
    this.onTap,
    super.key,
  });

  final String leftCode;
  final String rightCode;
  final String time;
  final String day;
  final String leagueLine;
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
              _codeColumn(leftCode, 'C'),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      day,
                      style: const TextStyle(
                        color: DashboardColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    if (leagueLine.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        leagueLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: DashboardColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _codeColumn(rightCode, 'B'),
              const Icon(Icons.chevron_right, color: DashboardColors.textSecondary),
            ],
          ),
        ),
        if (onProfileTap != null)
          Positioned(
            top: AppSpacing.sm,
            right: 48,
            child: ProfileAvatarChip(
              photoUrl: userPhotoUrl,
              radius: 15,
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

  Widget _codeColumn(String code, String letter) {
    return SizedBox(
      width: 48,
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: DashboardColors.bgSurface,
            child: Text(letter, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            code,
            style: const TextStyle(
              color: DashboardColors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

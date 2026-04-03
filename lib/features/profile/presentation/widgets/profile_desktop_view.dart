import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_achievement_banner.dart';
import 'profile_desktop_top_bar.dart';
import 'profile_performance_toggle.dart';
import 'profile_sport_stat_card.dart';
import 'profile_summary_stats_row.dart';
import 'profile_user_column.dart';

class ProfileDesktopView extends StatefulWidget {
  const ProfileDesktopView({
    required this.profile,
    required this.isOwnProfile,
    super.key,
  });

  final UserProfileEntity profile;
  final bool isOwnProfile;

  @override
  State<ProfileDesktopView> createState() => _ProfileDesktopViewState();
}

class _ProfileDesktopViewState extends State<ProfileDesktopView> {
  bool _seasonSelected = true;

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileDesktopTopBar(streakDays: p.streakDays),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 320, child: ProfileUserColumn(profile: p)),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfileSummaryStatsRow(
                        matches: p.matches,
                        wins: p.wins,
                        leagues: p.leaguesJoined,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Performance Breakdown',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: DashboardColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          ProfilePerformanceToggle(
                            seasonSelected: _seasonSelected,
                            onSeason: () => setState(() => _seasonSelected = true),
                            onAllTime: () => setState(() => _seasonSelected = false),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (final s in p.sports) ProfileSportStatCard(section: s),
                      ProfileAchievementBanner(achievement: p.achievement),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

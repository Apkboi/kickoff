import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/user_profile_entity.dart';
import 'profile_achievement_banner.dart';
import 'profile_avatar_ring.dart';
import 'profile_sport_stat_card.dart';
import 'profile_summary_stats_row.dart';
import 'profile_xp_bar.dart';
import '../controllers/profile_bloc.dart';
import '../controllers/profile_event.dart';

class ProfileMobileView extends StatelessWidget {
  const ProfileMobileView({
    required this.profile,
    required this.isOwnProfile,
    super.key,
  });

  final UserProfileEntity profile;
  final bool isOwnProfile;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'KickOff',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: DashboardColors.accentGreen,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined, color: DashboardColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.md),
                ProfileAvatarRing(profile: profile),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        profile.displayName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: DashboardColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    if (isOwnProfile)
                      IconButton(
                        tooltip: 'Edit name',
                        onPressed: () => _showEditNameDialog(context, profile.displayName),
                        icon: const Icon(Icons.edit_outlined, color: DashboardColors.textSecondary, size: 20),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${profile.tagline} • ${profile.locationLine}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ProfileXpBar(
                  level: profile.level,
                  xpCurrent: profile.xpCurrent,
                  xpToNext: profile.xpToNext,
                  progress: profile.xpProgress,
                ),
                const SizedBox(height: AppSpacing.lg),
                ProfileSummaryStatsRow(
                  matches: profile.matches,
                  wins: profile.wins,
                  leagues: profile.leaguesJoined,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sport Statistics',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: DashboardColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'VIEW ALL',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: DashboardColors.accentGreen,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
                for (final s in profile.sports) ProfileSportStatCard(section: s),
                ProfileAchievementBanner(achievement: profile.achievement),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

void _showEditNameDialog(BuildContext context, String current) {
  final controller = TextEditingController(text: current);
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: DashboardColors.bgCard,
      title: const Text('Display name', style: TextStyle(color: DashboardColors.textPrimary)),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: DashboardColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Your name',
          hintStyle: TextStyle(color: DashboardColors.textSecondary),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        TextButton(
          onPressed: () {
            context.read<ProfileBloc>().add(ProfileDisplayNameSubmitted(controller.text));
            Navigator.pop(ctx);
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

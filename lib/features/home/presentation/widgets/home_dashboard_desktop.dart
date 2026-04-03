import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/stream_link_launch_sheet.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import '../controllers/live_matches_bloc.dart';
import '../controllers/upcoming_matches_bloc.dart';
import '../utils/home_fixture_formatters.dart';
import 'home_dashboard_hero.dart';
import 'home_dashboard_nav.dart';
import 'home_desktop_trending_column.dart';
import 'home_live_match_tile.dart';
import 'home_section_header.dart';
import 'home_upcoming_tile_desktop.dart';

class HomeDashboardDesktop extends StatelessWidget {
  const HomeDashboardDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final profilePhoto = authState is AuthLoaded ? authState.user.photoUrl : null;
    void openProfile() => HomeDashboardNav.openEditProfile(context);

    return BlocBuilder<LiveMatchesBloc, LiveMatchesState>(
      builder: (context, liveState) {
        return BlocBuilder<UpcomingMatchesBloc, UpcomingMatchesState>(
          builder: (context, upState) {
            final live = liveState is LiveMatchesReady
                ? liveState.matches
                : <HomeLiveMatchEntity>[];
            final upcoming = upState is UpcomingMatchesReady
                ? upState.matches
                : <HomeUpcomingFixtureEntity>[];
            return SingleChildScrollView(
              key: ValueKey('${live.length}_${upcoming.length}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const HomeTopBar(),
                  // const SizedBox(height: AppSpacing.lg),
                  HomeDashboardHero(
                    liveMatches: live,
                    upcomingMatches: upcoming,
                    compact: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 900) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _LiveBlock(
                              profilePhoto: profilePhoto,
                              onProfileTap: openProfile,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _UpcomingBlock(
                              profilePhoto: profilePhoto,
                              onProfileTap: openProfile,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            const HomeDesktopTrendingColumn(),
                          ],
                        );
                      }
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _LiveBlock(
                                profilePhoto: profilePhoto,
                                onProfileTap: openProfile,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _UpcomingBlock(
                                profilePhoto: profilePhoto,
                                onProfileTap: openProfile,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            const Expanded(child: HomeDesktopTrendingColumn()),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LiveBlock extends StatelessWidget {
  const _LiveBlock({
    required this.profilePhoto,
    required this.onProfileTap,
  });

  final String? profilePhoto;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveMatchesBloc, LiveMatchesState>(
      builder: (context, state) {
        if (state is LiveMatchesLoadError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSectionHeader(
                title: 'Live Matches',
                actionLabel: '',
                onAction: () => HomeDashboardNav.openExplore(context),
              ),
              Text(state.message, style: const TextStyle(color: DashboardColors.textSecondary)),
              TextButton(
                onPressed: () => context.read<LiveMatchesBloc>().add(const LiveMatchesStarted()),
                child: const Text('Retry'),
              ),
            ],
          );
        }
        final live = state is LiveMatchesReady ? state.matches : [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSectionHeader(
              title: 'Live Matches',
              actionLabel: 'VIEW ALL',
              onAction: () => HomeDashboardNav.openExplore(context),
            ),
            if (live.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  'No matches live right now.',
                  style: TextStyle(color: DashboardColors.textSecondary, fontSize: 13),
                ),
              )
            else
              for (final m in live)
                Padding(
                  key: ValueKey(m.matchId),
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: HomeLiveMatchTile(
                    league: m.leagueName,
                    home: m.homeName,
                    away: m.awayName,
                    homeScore: m.homeScore,
                    awayScore: m.awayScore,
                    progress: m.progress,
                    userPhotoUrl: profilePhoto,
                    onProfileTap: onProfileTap,
                    onTap: () async {
                      if (m.streamLinks.isNotEmpty) {
                        await launchStreamLinksOrSheet(context, m.streamLinks);
                      } else {
                        HomeDashboardNav.openMatch(context, m.leagueId, m.matchId);
                      }
                    },
                  ),
                ),
          ],
        );
      },
    );
  }
}

class _UpcomingBlock extends StatelessWidget {
  const _UpcomingBlock({
    required this.profilePhoto,
    required this.onProfileTap,
  });

  final String? profilePhoto;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingMatchesBloc, UpcomingMatchesState>(
      builder: (context, state) {
        if (state is UpcomingMatchesLoadError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeSectionHeader(
                title: 'Upcoming',
                trailing: IconButton(
                  onPressed: () => HomeDashboardNav.openExplore(context),
                  icon: const Icon(Icons.tune, color: DashboardColors.textSecondary),
                ),
              ),
              Text(state.message, style: const TextStyle(color: DashboardColors.textSecondary)),
              TextButton(
                onPressed: () =>
                    context.read<UpcomingMatchesBloc>().add(const UpcomingMatchesStarted()),
                child: const Text('Retry'),
              ),
            ],
          );
        }
        final upcoming = state is UpcomingMatchesReady ? state.matches : [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSectionHeader(
              title: 'Upcoming',
              trailing: IconButton(
                onPressed: () => HomeDashboardNav.openExplore(context),
                icon: const Icon(Icons.tune, color: DashboardColors.textSecondary),
              ),
            ),
            if (upcoming.isEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  'No upcoming fixtures.',
                  style: TextStyle(color: DashboardColors.textSecondary, fontSize: 13),
                ),
              )
            else
              for (final u in upcoming)
                HomeUpcomingTileDesktop(
                  key: ValueKey(u.matchId),
                  dayLabel: HomeFixtureFormatters.desktopDayLabel(u.kickoffAt),
                  time: HomeFixtureFormatters.timeLabel(u.kickoffAt),
                  title: '${u.homeName} vs ${u.awayName}',
                  subtitle: u.leagueName,
                  userPhotoUrl: profilePhoto,
                  onProfileTap: onProfileTap,
                  onTap: () => HomeDashboardNav.openMatch(context, u.leagueId, u.matchId),
                ),
          ],
        );
      },
    );
  }
}

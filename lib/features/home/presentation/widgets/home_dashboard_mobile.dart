import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/home_live_match_entity.dart';
import '../../domain/entities/home_trending_league_entity.dart';
import '../../domain/entities/home_upcoming_fixture_entity.dart';
import '../controllers/live_matches_bloc.dart';
import '../controllers/trending_leagues_bloc.dart';
import '../controllers/upcoming_matches_bloc.dart';
import '../utils/home_fixture_formatters.dart';
import 'home_dashboard_hero.dart';
import 'home_dashboard_nav.dart';
import 'home_filter_chips.dart';
import 'home_live_match_tile.dart';
import 'home_mobile_header.dart';
import 'home_section_header.dart';
import 'home_trending_leagues_strip.dart';
import 'home_upcoming_fixture_mobile_tile.dart';

class HomeDashboardMobile extends StatefulWidget {
  const HomeDashboardMobile({super.key});

  @override
  State<HomeDashboardMobile> createState() => _HomeDashboardMobileState();
}

class _HomeDashboardMobileState extends State<HomeDashboardMobile> {
  final _scroll = ScrollController();
  final _liveKey = GlobalKey();
  final _upcomingKey = GlobalKey();
  final _trendingKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onChip(int i) {
    if (i == 3) {
      HomeDashboardNav.openExplore(context);
      return;
    }
    final keys = [_liveKey, _upcomingKey, _trendingKey];
    final ctx = keys[i].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final profilePhoto = authState is AuthLoaded ? authState.user.photoUrl : null;
    void openProfile() => HomeDashboardNav.openEditProfile(context);

    return BlocBuilder<LiveMatchesBloc, LiveMatchesState>(
      builder: (context, liveState) {
        return BlocBuilder<UpcomingMatchesBloc, UpcomingMatchesState>(
          builder: (context, upState) {
            return BlocBuilder<TrendingLeaguesBloc, TrendingLeaguesState>(
              builder: (context, trState) {
                final live = _liveList(liveState);
                final upcoming = _upcomingList(upState);
                final trending = _trendingList(trState);
                return SingleChildScrollView(
                  controller: _scroll,
                  key: ValueKey(
                    '${live.length}_${upcoming.length}_${trending.length}',
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppSpacing.lg),
                        const HomeMobileHeader(),
                        // const SizedBox(height: AppSpacing.lg),
                        // HomeFilterChips(onChipTap: _onChip),
                        const SizedBox(height: AppSpacing.lg),
                        HomeDashboardHero(
                          liveMatches: live,
                          upcomingMatches: upcoming,
                          compact: true,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        KeyedSubtree(
                          key: _liveKey,
                          child: HomeSectionHeader(
                            title: 'Live Matches',
                            actionLabel: '',
                            onAction: () => HomeDashboardNav.openExplore(context),
                          ),
                        ),
                        if (liveState is LiveMatchesLoadError)
                          _retry(
                            liveState.message,
                            () => context.read<LiveMatchesBloc>().add(const LiveMatchesStarted()),
                          )
                        else if (live.isEmpty)
                          _empty('No matches live right now.')
                        else
                          ...live.map(
                            (m) => Padding(
                              key: ValueKey(m.matchId),
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: HomeLiveMatchTile(
                                league: m.leagueName,
                                minute: m.elapsedMinute,
                                home: m.homeName,
                                away: m.awayName,
                                homeScore: m.homeScore,
                                awayScore: m.awayScore,
                                progress: m.progress,
                                userPhotoUrl: profilePhoto,
                                onProfileTap: openProfile,
                                onTap: () =>
                                    HomeDashboardNav.openMatch(context, m.leagueId, m.matchId),
                              ),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        KeyedSubtree(
                          key: _upcomingKey,
                          child: const HomeSectionHeader(title: 'Upcoming Fixtures'),
                        ),
                        if (upState is UpcomingMatchesLoadError)
                          _retry(
                            upState.message,
                            () =>
                                context.read<UpcomingMatchesBloc>().add(const UpcomingMatchesStarted()),
                          )
                        else if (upcoming.isEmpty)
                          _empty('No upcoming fixtures.')
                        else
                          ...upcoming.map(
                            (u) => HomeUpcomingFixtureMobileTile(
                              key: ValueKey(u.matchId),
                              leftCode: HomeFixtureFormatters.shortCode(u.homeName),
                              rightCode: HomeFixtureFormatters.shortCode(u.awayName),
                              time: HomeFixtureFormatters.timeLabel(u.kickoffAt),
                              day: HomeFixtureFormatters.dayLabel(u.kickoffAt),
                              leagueLine: u.leagueName,
                              userPhotoUrl: profilePhoto,
                              onProfileTap: openProfile,
                              onTap: () =>
                                  HomeDashboardNav.openMatch(context, u.leagueId, u.matchId),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        KeyedSubtree(
                          key: _trendingKey,
                          child: HomeSectionHeader(
                            title: 'Trending Leagues',
                            actionLabel: 'View All',
                            onAction: () => HomeDashboardNav.openExplore(context),
                          ),
                        ),
                        if (trState is TrendingLeaguesLoadError)
                          _retry(
                            trState.message,
                            () => context
                                .read<TrendingLeaguesBloc>()
                                .add(const TrendingLeaguesStarted()),
                          )
                        else
                          HomeTrendingLeaguesStrip(
                            leagues: trending,
                            onLeagueTap: (id) => HomeDashboardNav.openLeague(context, id),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<HomeLiveMatchEntity> _liveList(LiveMatchesState s) {
    if (s is LiveMatchesReady) return s.matches;
    return [];
  }

  List<HomeUpcomingFixtureEntity> _upcomingList(UpcomingMatchesState s) {
    if (s is UpcomingMatchesReady) return s.matches;
    return [];
  }

  List<HomeTrendingLeagueEntity> _trendingList(TrendingLeaguesState s) {
    if (s is TrendingLeaguesReady) return s.leagues;
    return [];
  }

  Widget _empty(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        text,
        style: const TextStyle(color: DashboardColors.textSecondary, fontSize: 13),
      ),
    );
  }

  Widget _retry(String message, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(color: DashboardColors.textSecondary, fontSize: 13)),
          TextButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

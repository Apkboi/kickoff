import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/home_trending_league_entity.dart';
import '../controllers/trending_leagues_bloc.dart';
import '../models/home_weekly_chart_defaults.dart';
import 'home_dashboard_nav.dart';
import 'home_league_rank_tile.dart';
import 'home_section_header.dart';
import 'home_weekly_bar_chart.dart';

class HomeDesktopTrendingColumn extends StatelessWidget {
  const HomeDesktopTrendingColumn({super.key});

  static const _icons = [Icons.star, Icons.emoji_events, Icons.sports_soccer];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendingLeaguesBloc, TrendingLeaguesState>(
      builder: (context, state) {
        final leagues =
            state is TrendingLeaguesReady ? state.leagues : <HomeTrendingLeagueEntity>[];
        final error = state is TrendingLeaguesLoadError ? state.message : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSectionHeader(
              title: 'Trending Leagues',
              trailing: IconButton(
                onPressed: () => HomeDashboardNav.openExplore(context),
                icon: const Icon(Icons.trending_up, color: DashboardColors.accentGreen),
              ),
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(error, style: const TextStyle(color: DashboardColors.textSecondary, fontSize: 13)),
                    TextButton(
                      onPressed: () =>
                          context.read<TrendingLeaguesBloc>().add(const TrendingLeaguesStarted()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: DashboardColors.bgCard,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: DashboardColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (error == null && leagues.isEmpty)
                    const Text(
                      'No published leagues yet.',
                      style: TextStyle(color: DashboardColors.textSecondary, fontSize: 13),
                    )
                  else if (error == null)
                    for (var i = 0; i < leagues.length && i < 6; i++)
                      HomeLeagueRankTile(
                        key: ValueKey(leagues[i].id),
                        name: leagues[i].name,
                        subtitle: leagues[i].subtitle,
                        points: leagues[i].sportLabel,
                        iconData: _icons[i % _icons.length],
                        iconColor: DashboardColors.accentGreen,
                        onTap: () => HomeDashboardNav.openLeague(context, leagues[i].id),
                      ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => HomeDashboardNav.openExplore(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: DashboardColors.textPrimary,
                        side: const BorderSide(color: DashboardColors.borderSubtle),
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      ),
                      child: const Text('EXPLORE MORE LEAGUES'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: DashboardColors.bgCard,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: DashboardColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.show_chart, color: DashboardColors.accentGreen),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Weekly Performance',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: DashboardColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  HomeWeeklyBarChart(values: HomeWeeklyChartDefaults.barRelativeHeights),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

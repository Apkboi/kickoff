import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/usecases/watch_league_fixtures_usecase.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';

/// Live / upcoming matches fans open for the read-only [MatchDetailScreen].
/// Not used from the admin manage-league flow.
class LeagueSpectatorMatchesSection extends StatelessWidget {
  const LeagueSpectatorMatchesSection({
    required this.competitionId,
    required this.fixtures,
    super.key,
  });

  final String competitionId;
  final List<LeagueFixtureSummaryEntity> fixtures;

  static const int _pageSize = 4;

  @override
  Widget build(BuildContext context) {
    final watch = getIt<WatchLeagueFixturesUseCase>();
    return StreamBuilder<List<LeagueFixtureSummaryEntity>>(
      stream: watch(competitionId: competitionId),
      builder: (context, snap) {
        final liveFixtures = (snap.data ?? fixtures).take(_pageSize).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Matches & fixtures',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (liveFixtures.length == _pageSize)
                      TextButton(
                        onPressed: () => context.push(AppRoutes.competitionFixturesPath(competitionId)),
                        child: Text(
                          'View all',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: DashboardColors.accentGreen,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ),
                    Text(
                      'Realtime',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (liveFixtures.isEmpty)
              Text(
                'No fixtures scheduled yet.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
              )
            else
              ...liveFixtures.map(
                (r) => Padding(
                  key: ValueKey<String>(r.matchId),
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      onTap: () => context.push(AppRoutes.matchDetailPath(competitionId, r.matchId)),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: DashboardColors.bgCard,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: DashboardColors.borderSubtle),
                        ),
                        child: _FootballFixtureTile(fixture: r),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FootballFixtureTile extends StatelessWidget {
  const _FootballFixtureTile({required this.fixture});

  final LeagueFixtureSummaryEntity fixture;

  @override
  Widget build(BuildContext context) {
    final teams = fixture.headline.split(RegExp(r'\s+vs\s+', caseSensitive: false));
    final home = teams.isNotEmpty ? teams.first : 'Home';
    final away = teams.length > 1 ? teams[1] : 'Away';
    final scoreLabel = fixture.phase == LeagueFixturePhase.scheduled
        ? '-'
        : '${fixture.homeScore} - ${fixture.awayScore}';
    return Row(
      children: [
        Expanded(
          child: Text(
            home,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Column(
            children: [
              Text(
                scoreLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              Text(
                fixture.statusLine,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            away,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Icon(Icons.chevron_right, color: DashboardColors.textSecondary.withValues(alpha: 0.6)),
      ],
    );
  }
}

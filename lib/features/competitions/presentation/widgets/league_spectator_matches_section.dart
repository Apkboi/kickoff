import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/app_datetime_format.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/usecases/watch_league_fixtures_usecase.dart';
import 'league_spectator_filter_dropdown.dart';
import 'league_spectator_fixture_filters.dart';
import 'league_spectator_fixture_tile.dart';

/// Live / upcoming matches fans open for the read-only [MatchDetailScreen].
class LeagueSpectatorMatchesSection extends StatefulWidget {
  const LeagueSpectatorMatchesSection({
    required this.competitionId,
    required this.fixtures,
    super.key,
  });

  final String competitionId;
  final List<LeagueFixtureSummaryEntity> fixtures;

  static const int pageSize = 8;

  @override
  State<LeagueSpectatorMatchesSection> createState() => _LeagueSpectatorMatchesSectionState();
}

class _LeagueSpectatorMatchesSectionState extends State<LeagueSpectatorMatchesSection> {
  DateTime? _dateFilter;
  LeagueSpectatorResultFilter _resultFilter = LeagueSpectatorResultFilter.all;

  @override
  Widget build(BuildContext context) {
    final watch = getIt<WatchLeagueFixturesUseCase>();
    return StreamBuilder<List<LeagueFixtureSummaryEntity>>(
      stream: watch(competitionId: widget.competitionId),
      builder: (context, snap) {
        final raw = snap.data ?? widget.fixtures;
        final kickoffDates = distinctSortedKickoffDates(raw);
        if (_dateFilter != null && !kickoffDates.contains(_dateFilter)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _dateFilter = null);
          });
        }
        final filtered = applyLeagueSpectatorFilters(
          all: raw,
          dateFilter: _dateFilter,
          resultFilter: _resultFilter,
        );
        final page = filtered.take(LeagueSpectatorMatchesSection.pageSize).toList();

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
                Text(
                  'Realtime',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                LeagueSpectatorFilterDropdown<DateTime?>(
                  label: 'Date',
                  value: _dateFilter,
                  items: [
                    (null, 'All dates'),
                    ...kickoffDates.map((d) => (d, AppDateTimeFormat.calendarFilterDate(d))),
                  ],
                  onChanged: (v) => setState(() => _dateFilter = v),
                ),
                LeagueSpectatorFilterDropdown<LeagueSpectatorResultFilter>(
                  label: 'Show',
                  value: _resultFilter,
                  items: [
                    (LeagueSpectatorResultFilter.all, LeagueSpectatorResultFilter.all.label),
                    (LeagueSpectatorResultFilter.upcomingAndLive, LeagueSpectatorResultFilter.upcomingAndLive.label),
                    (LeagueSpectatorResultFilter.finished, LeagueSpectatorResultFilter.finished.label),
                  ],
                  onChanged: (v) => setState(() => _resultFilter = v ?? LeagueSpectatorResultFilter.all),
                ),
                if (filtered.length >= LeagueSpectatorMatchesSection.pageSize)
                  TextButton(
                    onPressed: () => context.push(AppRoutes.competitionFixturesPath(widget.competitionId)),
                    child: Text(
                      'View all',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: DashboardColors.accentGreen,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (page.isEmpty)
              Text(
                'No fixtures match these filters.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
              )
            else
              ...page.map(
                (r) => Padding(
                  key: ValueKey<String>(r.matchId),
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      onTap: () => context.push(AppRoutes.matchDetailPath(widget.competitionId, r.matchId)),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: DashboardColors.bgCard,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: DashboardColors.borderSubtle),
                        ),
                        child: LeagueSpectatorFixtureTile(fixture: r),
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

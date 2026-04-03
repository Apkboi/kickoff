import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/usecases/watch_league_fixtures_usecase.dart';

class LeagueFixturesBrowserView extends StatefulWidget {
  const LeagueFixturesBrowserView({
    required this.competitionId,
    required this.onFixtureTap,
    this.selectedMatchId,
    super.key,
  });

  final String competitionId;
  final String? selectedMatchId;
  final ValueChanged<LeagueFixtureSummaryEntity> onFixtureTap;

  @override
  State<LeagueFixturesBrowserView> createState() => _LeagueFixturesBrowserViewState();
}

enum _FixtureBucket { all, fixtures, results, live }

class _LeagueFixturesBrowserViewState extends State<LeagueFixturesBrowserView> {
  _FixtureBucket _bucket = _FixtureBucket.all;
  String _week = 'All weeks';
  bool _sortByDate = false;
  final _watchFixtures = getIt<WatchLeagueFixturesUseCase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LeagueFixtureSummaryEntity>>(
      stream: _watchFixtures(competitionId: widget.competitionId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final all = snap.data!;
        final weeks = _weeks(all);
        if (!weeks.contains(_week)) _week = 'All weeks';
        final filtered = _apply(all);
        return Column(
          children: [
            _filters(context, weeks),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final fixture = filtered[i];
                  return _FixtureFootballCard(
                    fixture: fixture,
                    selected: fixture.matchId == widget.selectedMatchId,
                    onTap: () => widget.onFixtureTap(fixture),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<String> _weeks(List<LeagueFixtureSummaryEntity> list) {
    final set = <String>{'All weeks'};
    for (final f in list) {
      final m = RegExp(r'Round\s+(\d+)', caseSensitive: false).firstMatch(f.statusLine);
      if (m != null) set.add('Week ${m.group(1)}');
    }
    return set.toList();
  }

  List<LeagueFixtureSummaryEntity> _apply(List<LeagueFixtureSummaryEntity> fixtures) {
    var out = fixtures.where((f) {
      final statusMatch = switch (_bucket) {
        _FixtureBucket.all => true,
        _FixtureBucket.fixtures => f.phase != LeagueFixturePhase.finished,
        _FixtureBucket.results => f.phase == LeagueFixturePhase.finished,
        _FixtureBucket.live => f.phase == LeagueFixturePhase.live,
      };
      if (!statusMatch) return false;
      if (_week == 'All weeks') return true;
      return f.statusLine.toLowerCase().contains(_week.replaceFirst('Week', 'round').toLowerCase());
    }).toList();
    out.sort((a, b) {
      if (_sortByDate) {
        final aDate = a.kickoffAt;
        final bDate = b.kickoffAt;
        if (aDate == null && bDate == null) return a.matchId.compareTo(b.matchId);
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return aDate.compareTo(bDate);
      }
      return a.statusLine.compareTo(b.statusLine);
    });
    return out;
  }

  Widget _filters(BuildContext context, List<String> weeks) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _bucketChip('All', _FixtureBucket.all),
          _bucketChip('Fixtures', _FixtureBucket.fixtures),
          _bucketChip('Results', _FixtureBucket.results),
          _bucketChip('Live', _FixtureBucket.live),
          DropdownButton<String>(
            value: _week,
            items: weeks.map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
            onChanged: (v) => setState(() => _week = v ?? 'All weeks'),
          ),
          FilterChip(
            selected: _sortByDate,
            label: const Text('Sort by date'),
            onSelected: (v) => setState(() => _sortByDate = v),
          ),
        ],
      ),
    );
  }

  Widget _bucketChip(String label, _FixtureBucket value) {
    return ChoiceChip(
      label: Text(label),
      selected: _bucket == value,
      onSelected: (_) => setState(() => _bucket = value),
    );
  }
}

class _FixtureFootballCard extends StatelessWidget {
  const _FixtureFootballCard({
    required this.fixture,
    required this.selected,
    required this.onTap,
  });

  final LeagueFixtureSummaryEntity fixture;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scoreLabel = fixture.phase == LeagueFixturePhase.scheduled
        ? '-'
        : '${fixture.homeScore} - ${fixture.awayScore}';
    final teams = fixture.headline.split(RegExp(r'\s+vs\s+', caseSensitive: false));
    final home = teams.isNotEmpty ? teams.first : 'Home';
    final away = teams.length > 1 ? teams[1] : 'Away';
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: selected ? DashboardColors.accentGreen : DashboardColors.borderSubtle,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(home, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                  Text(scoreLabel, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                  Text(away, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                fixture.statusLine,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


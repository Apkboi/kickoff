import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';

class LeagueSpectatorFixtureTile extends StatelessWidget {
  const LeagueSpectatorFixtureTile({required this.fixture, super.key});

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

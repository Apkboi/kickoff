import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';

class ManageLeagueFixtureAdminCard extends StatelessWidget {
  const ManageLeagueFixtureAdminCard({
    required this.fixture,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final LeagueFixtureSummaryEntity fixture;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final live = fixture.phase == LeagueFixturePhase.live;
    final scheduled = fixture.phase == LeagueFixturePhase.scheduled;
    final homeScore = scheduled ? '-' : '${fixture.homeScore}';
    final awayScore = scheduled ? '-' : '${fixture.awayScore}';

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
              color: selected
                  ? DashboardColors.accentGreen
                  : live
                      ? DashboardColors.accentGreen.withValues(alpha: 0.35)
                      : DashboardColors.borderSubtle,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fixture.headline,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: DashboardColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: live
                          ? DashboardColors.accentGreen.withValues(alpha: 0.2)
                          : scheduled
                              ? DashboardColors.bgSurface
                              : DashboardColors.bgSurface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      live
                          ? 'LIVE'
                          : scheduled
                              ? 'SCHED'
                              : 'FT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: live ? DashboardColors.accentNeon : DashboardColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                fixture.statusLine,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeScore,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Text('—', style: TextStyle(color: DashboardColors.textSecondary)),
                  Text(
                    awayScore,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


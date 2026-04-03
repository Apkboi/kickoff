import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';

class ManageLeagueMobileFixturesStrip extends StatelessWidget {
  const ManageLeagueMobileFixturesStrip({
    required this.competitionId,
    super.key,
  });

  final String competitionId;

  static const int _pageSize = 4;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageLeagueBloc, ManageLeagueState>(
      buildWhen: (a, b) => a is ManageLeagueLoaded || b is ManageLeagueLoaded,
      builder: (context, state) {
        if (state is! ManageLeagueLoaded) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select match',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: DashboardColors.textSecondary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 88,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.fixtures.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, i) {
                  final f = state.fixtures[i];
                  final sel = f.matchId == state.selectedMatchId;
                  return _FixtureChip(
                    fixture: f,
                    selected: sel,
                    onTap: () => context.read<ManageLeagueBloc>().add(ManageLeagueMatchSelected(f.matchId)),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (state.fixtures.length > _pageSize)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    final matchId = await context.push<String>(
                      '${AppRoutes.manageLeagueFixturesPath(competitionId)}?selected=${state.selectedMatchId}',
                    );
                    if (matchId == null || !context.mounted) return;
                    context.read<ManageLeagueBloc>().add(ManageLeagueMatchSelected(matchId));
                  },
                  child: Text(
                    'View all',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: DashboardColors.accentGreen,
                          fontWeight: FontWeight.w800,
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

class _FixtureChip extends StatelessWidget {
  const _FixtureChip({
    required this.fixture,
    required this.selected,
    required this.onTap,
  });

  final LeagueFixtureSummaryEntity fixture;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final live = fixture.phase == LeagueFixturePhase.live;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: selected ? DashboardColors.accentGreen : DashboardColors.borderSubtle,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                live ? 'LIVE' : 'FIX',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: live ? DashboardColors.accentNeon : DashboardColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              Text(
                fixture.headline,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

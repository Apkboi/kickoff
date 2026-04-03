import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';
import 'manage_league_fixture_admin_card.dart';

class ManageLeagueActiveMatchesSidebar extends StatefulWidget {
  const ManageLeagueActiveMatchesSidebar({
    required this.competitionId,
    super.key,
  });

  final String competitionId;

  static const int _pageSize = 4;

  @override
  State<ManageLeagueActiveMatchesSidebar> createState() => _ManageLeagueActiveMatchesSidebarState();
}

class _ManageLeagueActiveMatchesSidebarState extends State<ManageLeagueActiveMatchesSidebar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageLeagueBloc, ManageLeagueState>(
      buildWhen: (a, b) =>
          a is ManageLeagueLoaded ||
          b is ManageLeagueLoaded ||
          (a is ManageLeagueLoaded && b is ManageLeagueLoaded && a != b),
      builder: (context, state) {
        if (state is! ManageLeagueLoaded) {
          return const SizedBox.shrink();
        }

        final visibleFixtures = state.fixtures.take(ManageLeagueActiveMatchesSidebar._pageSize).toList();

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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: DashboardColors.accentGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        '${visibleFixtures.length} GAMES',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: DashboardColors.accentNeon,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                    if (state.fixtures.length == ManageLeagueActiveMatchesSidebar._pageSize)
                      Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.sm),
                        child: TextButton(
                          onPressed: () async {
                            final matchId = await context.push<String>(
                              '${AppRoutes.manageLeagueFixturesPath(widget.competitionId)}?selected=${state.selectedMatchId}',
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
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...visibleFixtures.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ManageLeagueFixtureAdminCard(
                  fixture: f,
                  selected: f.matchId == state.selectedMatchId,
                  onTap: () => context.read<ManageLeagueBloc>().add(ManageLeagueMatchSelected(f.matchId)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

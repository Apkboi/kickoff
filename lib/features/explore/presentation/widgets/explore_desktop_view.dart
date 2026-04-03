import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/explore_sort.dart';
import '../controllers/explore_bloc.dart';
import '../controllers/explore_event.dart';
import '../controllers/explore_state.dart';
import 'explore_filter_panel.dart';
import 'explore_league_grid_card.dart';
import 'explore_search_field.dart';

class ExploreDesktopView extends StatelessWidget {
  const ExploreDesktopView({required this.loaded, super.key});

  final ExploreLoaded loaded;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExploreBloc>();
    final crossAxis = Responsive.isTablet(context) ? 2 : 3;
    final grid = loaded.filteredGrid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: ExploreSearchField(
                  hintText: 'Search leagues, tournaments, or clubs...',
                  onChanged: (q) => bloc.add(ExploreSearchChanged(q)),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: DashboardColors.accentGreen),
              ),
              const CircleAvatar(
                radius: 20,
                backgroundColor: DashboardColors.bgSurface,
                child: Icon(Icons.person, color: DashboardColors.textSecondary),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 260,
                child: ExploreFilterPanel(
                  filters: loaded.filters,
                  onFiltersChanged: (f) => bloc.add(ExploreFiltersChanged(f)),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore Leagues',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: DashboardColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Discover elite competitions starting this week.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: DashboardColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                        DropdownButton<ExploreSort>(
                          value: loaded.sort,
                          dropdownColor: DashboardColors.bgCard,
                          underline: const SizedBox.shrink(),
                          items: const [
                            DropdownMenuItem(
                              value: ExploreSort.popularity,
                              child: Text('Sort by: Popularity'),
                            ),
                            DropdownMenuItem(
                              value: ExploreSort.newest,
                              child: Text('Sort by: Newest'),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              bloc.add(ExploreSortChanged(v));
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: grid.isEmpty
                          ? Center(
                              child: Text(
                                'No tournaments match your filters.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: DashboardColors.textSecondary,
                                    ),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxis,
                                mainAxisSpacing: AppSpacing.md,
                                crossAxisSpacing: AppSpacing.md,
                                childAspectRatio: 0.68,
                              ),
                              itemCount: grid.length,
                              itemBuilder: (context, i) => ExploreLeagueGridCard(league: grid[i]),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

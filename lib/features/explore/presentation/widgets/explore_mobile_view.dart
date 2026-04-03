import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../controllers/explore_bloc.dart';
import '../controllers/explore_event.dart';
import '../controllers/explore_state.dart';
import 'explore_filters_sheet.dart';
import 'explore_league_grid_card.dart';
import 'explore_search_field.dart';

class ExploreMobileView extends StatelessWidget {
  const ExploreMobileView({required this.loaded, super.key});

  final ExploreLoaded loaded;

  void _openFilters(BuildContext context) {
    final bloc = context.read<ExploreBloc>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ExploreFiltersSheet(
        feed: loaded.feed,
        searchQuery: loaded.searchQuery,
        sort: loaded.sort,
        initial: loaded.filters,
        onApply: (f) {
          bloc.add(ExploreFiltersChanged(f));
          Navigator.of(ctx).pop();
        },
        onReset: () => bloc.add(const ExploreFiltersReset()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExploreBloc>();
    final leagues = loaded.filteredGrid;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Explore',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: DashboardColors.accentGreen,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                IconButton(
                  onPressed: () => _openFilters(context),
                  icon: const Icon(Icons.tune, color: DashboardColors.accentGreen),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ExploreSearchField(
              hintText: 'Search leagues, teams, or players',
              onChanged: (q) => bloc.add(ExploreSearchChanged(q)),
            ),
          ),
        ),
        if (leagues.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'No leagues match your filters.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: DashboardColors.textSecondary),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.xl),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.54,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) => ExploreLeagueGridCard(league: leagues[i]),
                childCount: leagues.length,
              ),
            ),
          ),
      ],
    );
  }
}

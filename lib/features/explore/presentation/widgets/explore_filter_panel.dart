import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/explore_filters.dart';
import '../../domain/entities/explore_sport.dart';
import 'explore_filter_panel_rows.dart';

class ExploreFilterPanel extends StatelessWidget {
  const ExploreFilterPanel({
    required this.filters,
    required this.onFiltersChanged,
    super.key,
  });

  final ExploreFilters filters;
  final ValueChanged<ExploreFilters> onFiltersChanged;

  void _toggleSport(ExploreSport s, bool? checked) {
    final next = Set<ExploreSport>.from(filters.sports);
    if (checked == true) {
      next.add(s);
    } else {
      next.remove(s);
    }
    onFiltersChanged(filters.copyWith(sports: next));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ExploreFilterSectionTitle(title: 'SPORT'),
          ExploreFilterCheckboxRow(
            label: 'Soccer',
            value: filters.sports.contains(ExploreSport.soccer),
            onChanged: (v) => _toggleSport(ExploreSport.soccer, v),
          ),
          ExploreFilterCheckboxRow(
            label: 'Basketball',
            value: filters.sports.contains(ExploreSport.basketball),
            onChanged: (v) => _toggleSport(ExploreSport.basketball, v),
          ),
          ExploreFilterCheckboxRow(
            label: 'Tennis',
            value: filters.sports.contains(ExploreSport.tennis),
            onChanged: (v) => _toggleSport(ExploreSport.tennis, v),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ExploreFilterSectionTitle(title: 'FORMAT'),
          ExploreFilterCheckboxRow(
            label: 'Tournament',
            value: filters.tournament,
            onChanged: (v) => onFiltersChanged(filters.copyWith(tournament: v ?? false)),
          ),
          ExploreFilterCheckboxRow(
            label: 'Standard League',
            value: filters.standardLeague,
            onChanged: (v) => onFiltersChanged(filters.copyWith(standardLeague: v ?? false)),
          ),
          ExploreFilterCheckboxRow(
            label: 'Knockout',
            value: filters.knockout,
            onChanged: (v) => onFiltersChanged(filters.copyWith(knockout: v ?? false)),
          ),
          const SizedBox(height: AppSpacing.lg),
          const ExploreFilterSectionTitle(title: 'STATUS'),
          ExploreFilterDotRow(
            label: 'Registration Open',
            color: DashboardColors.accentGreen,
            selected: filters.registrationOpen,
            onTap: () => onFiltersChanged(filters.copyWith(registrationOpen: !filters.registrationOpen)),
          ),
          ExploreFilterDotRow(
            label: 'Live Now',
            color: DashboardColors.accentAmber,
            selected: filters.liveNow,
            onTap: () => onFiltersChanged(filters.copyWith(liveNow: !filters.liveNow)),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: DashboardColors.bgCard,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: DashboardColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Want a custom tournament? Set your own rules, seasons, and prizes for your team.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => context.push(AppRoutes.createLeague),
                  style: FilledButton.styleFrom(
                    backgroundColor: DashboardColors.accentGreen,
                    foregroundColor: DashboardColors.textOnAccent,
                  ),
                  child: const Text('Build Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

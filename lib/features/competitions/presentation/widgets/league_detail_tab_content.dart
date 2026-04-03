import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_detail_entity.dart';
import '../../domain/entities/standing_row_entity.dart';
import 'league_standings_table.dart';

class LeagueDetailTabContent extends StatefulWidget {
  const LeagueDetailTabContent({
    required this.detail,
    required this.standings,
    super.key,
  });

  final LeagueDetailEntity detail;
  final List<StandingRowEntity> standings;

  @override
  State<LeagueDetailTabContent> createState() => _LeagueDetailTabContentState();
}

class _LeagueDetailTabContentState extends State<LeagueDetailTabContent> {
  int _index = 0;

  static const _tabs = ['STANDINGS', 'BRACKET', 'PLAYERS'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i++)
                Padding(
                  padding: EdgeInsets.only(right: i < _tabs.length - 1 ? AppSpacing.sm : 0),
                  child: _SegmentTab(
                    label: _tabs[i],
                    selected: _index == i,
                    onTap: () => setState(() => _index = i),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (_index == 0) LeagueStandingsTable(rows: widget.standings),
        if (_index != 0)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Text(
                '${_tabs[_index]} — coming soon',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: DashboardColors.textSecondary),
              ),
            ),
          ),
      ],
    );
  }
}

class _SegmentTab extends StatelessWidget {
  const _SegmentTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? DashboardColors.chipSelectedBg : DashboardColors.chipUnselectedBg,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? DashboardColors.textOnAccent : DashboardColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ),
    );
  }
}

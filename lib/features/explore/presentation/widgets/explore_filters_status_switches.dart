import 'package:flutter/material.dart';

import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/explore_filters.dart';
import 'explore_filter_sheet_widgets.dart';

class ExploreFiltersStatusSwitches extends StatelessWidget {
  const ExploreFiltersStatusSwitches({
    required this.draft,
    required this.onChanged,
    super.key,
  });

  final ExploreFilters draft;
  final ValueChanged<ExploreFilters> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ExploreFilterSectionLabel(text: 'STATUS'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Open Registration',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textPrimary),
          ),
          value: draft.registrationOpen,
          activeThumbColor: DashboardColors.accentGreen,
          onChanged: (v) => onChanged(draft.copyWith(registrationOpen: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Live Now',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textPrimary),
          ),
          value: draft.liveNow,
          activeThumbColor: DashboardColors.accentGreen,
          onChanged: (v) => onChanged(draft.copyWith(liveNow: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Starting Soon',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textPrimary),
          ),
          value: draft.startingSoon,
          activeThumbColor: DashboardColors.accentGreen,
          onChanged: (v) => onChanged(draft.copyWith(startingSoon: v)),
        ),
      ],
    );
  }
}

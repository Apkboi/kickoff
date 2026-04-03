import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import 'explore_filter_sheet_widgets.dart';

class ExploreFiltersFeeLocationBlock extends StatelessWidget {
  const ExploreFiltersFeeLocationBlock({
    required this.feeRange,
    required this.onFeeChanged,
    required this.locationController,
    required this.onLocationChanged,
    super.key,
  });

  final RangeValues feeRange;
  final ValueChanged<RangeValues> onFeeChanged;
  final TextEditingController locationController;
  final ValueChanged<String> onLocationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ENTRY FEE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: DashboardColors.textSecondary,
                    letterSpacing: 1,
                  ),
            ),
            Text(
              '\$${feeRange.start.round()} - \$${feeRange.end.round()}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: DashboardColors.accentGreen),
            ),
          ],
        ),
        RangeSlider(
          values: feeRange,
          min: 0,
          max: 1000,
          divisions: 40,
          activeColor: DashboardColors.accentGreen,
          inactiveColor: DashboardColors.bgSurface,
          onChanged: onFeeChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('FREE', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary)),
            Text(r'$1000+', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const ExploreFilterSectionLabel(text: 'LOCATION'),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: locationController,
          onChanged: onLocationChanged,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.place_outlined, color: DashboardColors.textSecondary),
            hintText: 'City or Region',
            filled: true,
            fillColor: DashboardColors.bgCard,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
          ),
        ),
      ],
    );
  }
}

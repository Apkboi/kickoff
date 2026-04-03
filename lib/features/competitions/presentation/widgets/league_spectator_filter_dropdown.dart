import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class LeagueSpectatorFilterDropdown<T> extends StatelessWidget {
  const LeagueSpectatorFilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final String label;
  final T value;
  final List<(T, String)> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: DashboardColors.bgCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
        isDense: true,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isDense: true,
          isExpanded: false,
          dropdownColor: DashboardColors.bgCard,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textPrimary),
          items: [
            for (final e in items)
              DropdownMenuItem<T>(
                value: e.$1,
                child: Text(e.$2),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

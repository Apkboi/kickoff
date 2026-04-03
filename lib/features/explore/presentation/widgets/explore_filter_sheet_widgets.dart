import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ExploreFilterSectionLabel extends StatelessWidget {
  const ExploreFilterSectionLabel({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: DashboardColors.textSecondary,
            letterSpacing: 1,
          ),
    );
  }
}

class ExploreFilterSportChip extends StatelessWidget {
  const ExploreFilterSportChip({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: DashboardColors.accentGreen,
      checkmarkColor: DashboardColors.textOnAccent,
      labelStyle: TextStyle(
        color: selected ? DashboardColors.textOnAccent : DashboardColors.textSecondary,
        fontWeight: FontWeight.w700,
      ),
      backgroundColor: DashboardColors.bgCard,
    );
  }
}

class ExploreFilterFormatButton extends StatelessWidget {
  const ExploreFilterFormatButton({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? DashboardColors.accentGreen.withValues(alpha: 0.2) : DashboardColors.bgCard,
        foregroundColor: DashboardColors.textPrimary,
        side: BorderSide(color: selected ? DashboardColors.accentGreen : DashboardColors.borderSubtle),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, textAlign: TextAlign.left)),
          Icon(
            selected ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: selected ? DashboardColors.accentGreen : DashboardColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

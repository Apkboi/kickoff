import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ExploreFiltersSheetAppBar extends StatelessWidget {
  const ExploreFiltersSheetAppBar({
    required this.onClose,
    required this.onReset,
    super.key,
  });

  final VoidCallback onClose;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: DashboardColors.accentGreen),
          ),
          Text(
            'FILTERS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: DashboardColors.accentGreen,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
          ),
          TextButton(
            onPressed: onReset,
            child: const Text('RESET', style: TextStyle(color: DashboardColors.accentGreen)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/dashboard_colors.dart';

class PlaceholderNavScreen extends StatelessWidget {
  const PlaceholderNavScreen({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          '$title — coming soon',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DashboardColors.textSecondary,
              ),
        ),
      ),
    );
  }
}

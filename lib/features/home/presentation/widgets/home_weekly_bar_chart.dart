import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/dashboard_colors.dart';

class HomeWeeklyBarChart extends StatelessWidget {
  const HomeWeeklyBarChart({required this.values, super.key});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final max = values.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(values.length, (i) {
        final h = 80 * (values[i] / max);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Container(
              height: h.clamp(8, 80),
              decoration: BoxDecoration(
                color: DashboardColors.accentGreen.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
        );
      }),
    );
  }
}

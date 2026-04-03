import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class HomeFilterChips extends StatefulWidget {
  const HomeFilterChips({this.onChipTap, super.key});

  /// Called when a chip is selected (index 0–3: Live, Upcoming, Trending, Explore).
  final void Function(int index)? onChipTap;

  @override
  State<HomeFilterChips> createState() => _HomeFilterChipsState();
}

class _HomeFilterChipsState extends State<HomeFilterChips> {
  int _selected = 0;
  static const _labels = ['Live', 'Upcoming', 'Trending', 'Explore'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_labels.length, (i) {
          final isSel = i == _selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Material(
              color: isSel ? DashboardColors.chipSelectedBg : DashboardColors.chipUnselectedBg,
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                onTap: () {
                  setState(() => _selected = i);
                  widget.onChipTap?.call(i);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    _labels[i],
                    style: TextStyle(
                      color: isSel ? Colors.black : DashboardColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

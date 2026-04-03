import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ManageLeagueEventsShimmer extends StatelessWidget {
  const ManageLeagueEventsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        3,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: DashboardColors.bgCard,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: DashboardColors.borderSubtle),
            ),
          ),
        ),
      ),
    );
  }
}


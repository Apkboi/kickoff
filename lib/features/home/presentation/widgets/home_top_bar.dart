import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(color: DashboardColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search leagues, players or fixtures...',
              hintStyle: const TextStyle(color: DashboardColors.textSecondary, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: DashboardColors.textSecondary),
              filled: true,
              fillColor: DashboardColors.bgCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                borderSide: const BorderSide(color: DashboardColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                borderSide: const BorderSide(color: DashboardColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                borderSide: const BorderSide(color: DashboardColors.accentGreen),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              style: IconButton.styleFrom(
                backgroundColor: DashboardColors.bgCard,
                foregroundColor: DashboardColors.accentGreen,
              ),
              icon: const Icon(Icons.notifications_none),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: DashboardColors.accentGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: DashboardColors.accentNeon,
            side: const BorderSide(color: DashboardColors.accentGreen),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          icon: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: DashboardColors.accentNeon,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: DashboardColors.accentNeon,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          label: const Text('LIVE NOW', style: TextStyle(fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

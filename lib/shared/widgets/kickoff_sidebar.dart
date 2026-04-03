import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_radius.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/dashboard_colors.dart';
import 'kickoff_sidebar_user_section.dart';

class KickoffSidebar extends StatelessWidget {
  const KickoffSidebar({
    required this.selectedIndex,
    required this.onSelect,
    super.key,
  });

  /// Null when no shell route matches (e.g. Create League).
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.explore_outlined, label: 'Explore'),
    (icon: Icons.emoji_events_outlined, label: 'My tournaments'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DashboardColors.sidebarBg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.sports_soccer, color: DashboardColors.accentGreen, size: 28),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'KickOff',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: DashboardColors.accentGreen,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    final isActive = selectedIndex != null && index == selectedIndex;
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.button),
                        onTap: () => onSelect(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? DashboardColors.accentGreen.withValues(alpha: 0.12)
                                : null,
                            borderRadius: BorderRadius.circular(AppRadius.button),
                            border: Border(
                              left: BorderSide(
                                color: isActive
                                    ? DashboardColors.accentGreen
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 22,
                                color: isActive
                                    ? DashboardColors.accentGreen
                                    : DashboardColors.textSecondary,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: isActive
                                            ? DashboardColors.textPrimary
                                            : DashboardColors.textSecondary,
                                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push(AppRoutes.createLeague),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DashboardColors.accentGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                  child: const Text('Create League', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const KickoffSidebarUserSection(),
            ],
          ),
        ),
      ),
    );
  }
}

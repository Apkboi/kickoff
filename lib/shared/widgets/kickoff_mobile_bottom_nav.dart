import 'package:flutter/material.dart';

import '../../core/theme/dashboard_colors.dart';

/// Maps shell [navIndex] (0–4) to [NavigationBar] index. Profile = 4.
int kickoffMobileBarIndex(int navIndex) {
  return navIndex.clamp(0, 4);
}

int kickoffSemanticFromMobileBar(int barIndex) {
  return barIndex.clamp(0, 4);
}

class KickoffMobileBottomNav extends StatelessWidget {
  const KickoffMobileBottomNav({
    required this.navIndex,
    required this.onSemanticSelected,
    this.neutralSelection = false,
    super.key,
  });

  /// 0 home … 4 profile. Ignored when [neutralSelection] is true.
  final int? navIndex;
  final ValueChanged<int> onSemanticSelected;
  final bool neutralSelection;

  static const _destinations = <({
    IconData outlined,
    IconData filled,
    String label,
  })>[
    (outlined: Icons.home_outlined, filled: Icons.home, label: 'HOME'),
    (outlined: Icons.explore_outlined, filled: Icons.explore, label: 'EXPLORE'),
    (outlined: Icons.groups_outlined, filled: Icons.groups, label: 'LEAGUES'),
    (
      outlined: Icons.calendar_month_outlined,
      filled: Icons.calendar_month,
      label: 'SCHEDULE'
    ),
    (outlined: Icons.person_outline, filled: Icons.person, label: 'PROFILE'),
  ];

  @override
  Widget build(BuildContext context) {
    final bar = NavigationBar(
      height: 72,
      backgroundColor: Colors.transparent,
      indicatorColor: neutralSelection
          ? Colors.transparent
          : DashboardColors.accentGreen.withValues(alpha: 0.2),
      selectedIndex: neutralSelection ? 0 : kickoffMobileBarIndex(navIndex ?? 0),
      onDestinationSelected: (i) => onSemanticSelected(kickoffSemanticFromMobileBar(i)),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: [
        for (var i = 0; i < _destinations.length; i++)
          NavigationDestination(
            icon: Icon(
              _destinations[i].outlined,
              color: DashboardColors.textSecondary,
            ),
            selectedIcon: Icon(
              neutralSelection ? _destinations[i].outlined : _destinations[i].filled,
              color: neutralSelection
                  ? DashboardColors.textSecondary
                  : DashboardColors.accentNeon,
            ),
            label: _destinations[i].label,
          ),
      ],
    );

    if (neutralSelection) {
      return Theme(
        data: Theme.of(context).copyWith(
          navigationBarTheme: const NavigationBarThemeData(
            indicatorColor: Colors.transparent,
          ),
        ),
        child: bar,
      );
    }
    return bar;
  }
}

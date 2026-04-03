import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/utils/responsive.dart';
import 'kickoff_mobile_bottom_nav.dart';
import 'kickoff_sidebar.dart';

void _goNav(BuildContext context, int semanticIndex) {
  switch (semanticIndex) {
    case 0:
      context.go(AppRoutes.home);
      return;
    case 1:
      context.go(AppRoutes.explore);
      return;
    case 2:
      context.go(AppRoutes.competitions);
      return;
    case 3:
      context.go(AppRoutes.schedule);
      return;
    case 4:
      context.go(AppRoutes.profile);
      return;
    default:
      context.go(AppRoutes.home);
  }
}

void _handleMainNav(
  BuildContext context, {
  required int semanticIndex,
  void Function(int index)? onNavBranchSelected,
}) {
  if (onNavBranchSelected != null) {
    onNavBranchSelected(semanticIndex);
    return;
  }
  _goNav(context, semanticIndex);
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.body,
    required this.navIndex,
    this.showAppBar = true,
    this.backgroundColor,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.onNavBranchSelected,
    super.key,
  });

  final String title;
  final Widget body;
  final int? navIndex;

  /// When set (e.g. [StatefulNavigationShell]), switches tabs without losing branch stacks.
  final void Function(int index)? onNavBranchSelected;
  final bool showAppBar;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? DashboardColors.bgPrimary;
    final neutralNav = navIndex == null;

    if (Responsive.isDesktop(context)) {
      return Scaffold(
        backgroundColor: bg,
        body: Row(
          children: [
            SizedBox(
              width: 260,
              child: KickoffSidebar(
                selectedIndex: navIndex,
                onSelect: (i) => _handleMainNav(context, semanticIndex: i, onNavBranchSelected: onNavBranchSelected),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: body,
              ),
            ),
          ],
        ),
      );
    }

    if (Responsive.isTablet(context)) {
      const railDestinations = <({
        IconData outlined,
        IconData filled,
        String label,
      })>[
        (outlined: Icons.home_outlined, filled: Icons.home, label: 'Home'),
        (outlined: Icons.explore_outlined, filled: Icons.explore, label: 'Explore'),
        (
          outlined: Icons.emoji_events_outlined,
          filled: Icons.emoji_events,
          label: 'Leagues'
        ),
        (
          outlined: Icons.calendar_month_outlined,
          filled: Icons.calendar_month,
          label: 'Schedule'
        ),
        (outlined: Icons.person_outlined, filled: Icons.person, label: 'Profile'),
      ];

      final railIdx = neutralNav ? 0 : navIndex!.clamp(0, 4);

      final rail = NavigationRail(
        backgroundColor: DashboardColors.sidebarBg,
        selectedIndex: railIdx,
        onDestinationSelected: (i) =>
            _handleMainNav(context, semanticIndex: i, onNavBranchSelected: onNavBranchSelected),
        labelType: NavigationRailLabelType.all,
        destinations: [
          for (var i = 0; i < railDestinations.length; i++)
            NavigationRailDestination(
              icon: Icon(railDestinations[i].outlined),
              selectedIcon: Icon(
                neutralNav ? railDestinations[i].outlined : railDestinations[i].filled,
                color: neutralNav ? null : DashboardColors.accentGreen,
              ),
              label: Text(railDestinations[i].label),
            ),
        ],
      );

      return Scaffold(
        backgroundColor: bg,
        body: Row(
          children: [
            Theme(
              data: Theme.of(context).copyWith(
                navigationRailTheme: NavigationRailThemeData(
                  indicatorColor: neutralNav ? Colors.transparent : null,
                ),
              ),
              child: rail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: body,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: showAppBar
          ? AppBar(
              title: Text(title),
              backgroundColor: bg,
              foregroundColor: DashboardColors.textPrimary,
            )
          : null,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation:
          floatingActionButtonLocation ?? FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        child: Material(
          elevation: 8,
          shadowColor: Colors.black54,
          borderRadius: BorderRadius.circular(24),
          color: DashboardColors.bgCard,
          child: KickoffMobileBottomNav(
            navIndex: navIndex,
            neutralSelection: neutralNav,
            onSemanticSelected: (i) =>
                _handleMainNav(context, semanticIndex: i, onNavBranchSelected: onNavBranchSelected),
          ),
        ),
      ),
    );
  }
}

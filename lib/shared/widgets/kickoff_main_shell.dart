import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../core/utils/responsive.dart';
import 'app_scaffold.dart';

String _titleForLocation(String location) {
  final path = location.isEmpty ? AppRoutes.home : location;
  if (path.endsWith('/manage')) {
    return 'Manage League';
  }
  if (path.contains('/matches/')) {
    return 'Live match';
  }
  if (path.startsWith('${AppRoutes.competitions}/')) {
    return 'League';
  }
  return switch (path) {
    AppRoutes.home => 'KickOff',
    AppRoutes.explore => 'Explore',
    AppRoutes.competitions => 'My Leagues',
    AppRoutes.schedule => 'Schedule',
    AppRoutes.profile => 'Profile',
    AppRoutes.createLeague => 'Create League',
    _ => 'KickOff',
  };
}

/// Uses [StatefulNavigationShell] so each main tab keeps its own navigation stack on mobile.
class KickoffMainShell extends StatelessWidget {
  const KickoffMainShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final path = location.isEmpty ? AppRoutes.home : location;

    return AppScaffold(
      title: _titleForLocation(path),
      navIndex: navigationShell.currentIndex,
      onNavBranchSelected: navigationShell.goBranch,
      showAppBar: false,
      backgroundColor: DashboardColors.bgPrimary,
      floatingActionButton: Responsive.isMobile(context) &&
              (path == AppRoutes.home ||
                  path == AppRoutes.explore ||
                  path == AppRoutes.profile)
          ? FloatingActionButton(
              onPressed: () => context.push(AppRoutes.createLeague),
              backgroundColor: DashboardColors.accentGreen,
              foregroundColor: DashboardColors.textOnAccent,
              tooltip: 'Create league',
              child: const Icon(Icons.add),
            )
          : null,
      body: navigationShell,
    );
  }
}

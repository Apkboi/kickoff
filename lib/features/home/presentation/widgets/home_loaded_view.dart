import 'package:flutter/material.dart';

import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/responsive.dart';
import 'home_dashboard_desktop.dart';
import 'home_dashboard_mobile.dart';

class HomeLoadedView extends StatelessWidget {
  const HomeLoadedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: DashboardColors.bgPrimary,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: DashboardColors.textPrimary,
              displayColor: DashboardColors.textPrimary,
            ),
      ),
      child: Responsive.isDesktop(context) || Responsive.isTablet(context)
          ? const HomeDashboardDesktop()
          : const HomeDashboardMobile(),
    );
  }
}

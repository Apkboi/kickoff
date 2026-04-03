import 'package:flutter/material.dart';

import '../../../../core/theme/dashboard_colors.dart';

/// Desktop profile header — search / streak / extra icons removed per product spec.
class ProfileDesktopTopBar extends StatelessWidget {
  const ProfileDesktopTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Profile',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: DashboardColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

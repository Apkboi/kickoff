import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ManageLeagueDesktopToolbar extends StatelessWidget {
  const ManageLeagueDesktopToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search matches...',
              hintStyle: TextStyle(color: DashboardColors.textSecondary.withValues(alpha: 0.8)),
              filled: true,
              fillColor: DashboardColors.bgSurface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: DashboardColors.textSecondary),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings_outlined, color: DashboardColors.textSecondary),
        ),
      ],
    );
  }
}

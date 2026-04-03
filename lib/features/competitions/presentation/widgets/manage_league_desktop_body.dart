import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import 'manage_league_active_matches_sidebar.dart';
import 'manage_league_desktop_event_section.dart';
import 'manage_league_desktop_score_block.dart';
import 'manage_league_desktop_toolbar.dart';

class ManageLeagueDesktopBody extends StatelessWidget {
  const ManageLeagueDesktopBody({
    required this.competitionId,
    super.key,
  });

  final String competitionId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: ManageLeagueActiveMatchesSidebar(competitionId: competitionId),
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ManageLeagueDesktopToolbar(),
                const SizedBox(height: AppSpacing.lg),
                const ManageLeagueDesktopScoreBlock(),
                const ManageLeagueDesktopEventSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_card_status.dart';

class LeagueCardTrophyBox extends StatelessWidget {
  const LeagueCardTrophyBox({required this.status, super.key});

  final LeagueCardStatus status;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color iconColor;
    switch (status) {
      case LeagueCardStatus.live:
        bg = DashboardColors.accentGreen.withValues(alpha: 0.2);
        iconColor = DashboardColors.accentGreen;
      case LeagueCardStatus.upcoming:
        bg = DashboardColors.bgSurface;
        iconColor = DashboardColors.textSecondary;
      case LeagueCardStatus.private:
        bg = DashboardColors.bgSurface;
        iconColor = DashboardColors.textSecondary;
    }
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(Icons.emoji_events_outlined, color: iconColor, size: 22),
    );
  }
}

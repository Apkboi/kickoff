import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/competition_entity.dart';
import '../../domain/entities/league_card_status.dart';
import 'league_card_avatar_cluster.dart';
import 'league_card_status_badge.dart';
import 'league_card_trophy_box.dart';

class MyLeagueCard extends StatelessWidget {
  const MyLeagueCard({
    required this.competition,
    required this.onTap,
    super.key,
  });

  final CompetitionEntity competition;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = competition.status;
    return Material(
      color: DashboardColors.bgCard,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (competition.logoUrl != null && competition.logoUrl!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: Image.network(
                        competition.logoUrl!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => LeagueCardTrophyBox(status: status),
                      ),
                    )
                  else
                    LeagueCardTrophyBox(status: status),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: LeagueCardStatusBadge(status: status)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                competition.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: DashboardColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                competition.matchdayLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DashboardColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (competition.xpPoolLabel != null)
                    Text(
                      competition.xpPoolLabel!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: DashboardColors.accentAmber,
                            fontWeight: FontWeight.w600,
                          ),
                    )
                  else if (status == LeagueCardStatus.private)
                    Row(
                      children: [
                        const Icon(Icons.lock_outline, size: 16, color: DashboardColors.textSecondary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Private League',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: DashboardColors.textSecondary,
                              ),
                        ),
                      ],
                    )
                  else
                    LeagueCardAvatarCluster(showMe: competition.showMeBadge),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

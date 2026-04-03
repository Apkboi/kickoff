import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_detail_entity.dart';
import '../../domain/entities/standing_row_entity.dart';
import 'league_admin_section.dart';
import 'league_detail_hero.dart';
import 'league_detail_tab_content.dart';
import 'league_prediction_leaderboard_section.dart';
import 'league_spectator_matches_section.dart';

/// Desktop (≥1024px) league detail: two columns — fixtures/hero left, standings/admins right.
class CompetitionDetailDesktopBody extends StatelessWidget {
  const CompetitionDetailDesktopBody({
    required this.detail,
    required this.standings,
    required this.competitionId,
    required this.onBack,
    this.onManageLeague,
    super.key,
  });

  final LeagueDetailEntity detail;
  final List<StandingRowEntity> standings;
  final String competitionId;
  final VoidCallback onBack;
  final VoidCallback? onManageLeague;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: _LeftColumn(
                  detail: detail,
                  competitionId: competitionId,
                  onBack: onBack,
                  onManageLeague: onManageLeague,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                flex: 4,
                child: _RightColumn(
                  detail: detail,
                  standings: standings,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  const _LeftColumn({
    required this.detail,
    required this.competitionId,
    required this.onBack,
    this.onManageLeague,
  });

  final LeagueDetailEntity detail;
  final String competitionId;
  final VoidCallback onBack;
  final VoidCallback? onManageLeague;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
            ),
            Expanded(
              child: Text(
                detail.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: DashboardColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        LeagueDetailHero(detail: detail, compact: false),
        if (onManageLeague != null) ...[
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              onPressed: onManageLeague,
              icon: const Icon(Icons.tune_outlined),
              label: const Text('Manage tournament'),
              style: FilledButton.styleFrom(
                backgroundColor: DashboardColors.accentGreen,
                foregroundColor: DashboardColors.textOnAccent,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        LeagueSpectatorMatchesSection(
          competitionId: competitionId,
          fixtures: detail.fixtures,
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn({
    required this.detail,
    required this.standings,
  });

  final LeagueDetailEntity detail;
  final List<StandingRowEntity> standings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: DashboardColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'League overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: DashboardColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          LeaguePredictionLeaderboardSection(competitionId: detail.id),
          const SizedBox(height: AppSpacing.lg),
          LeagueDetailTabContent(detail: detail, standings: standings),
          const SizedBox(height: AppSpacing.lg),
          const Divider(height: 1, color: DashboardColors.borderSubtle),
          const SizedBox(height: AppSpacing.lg),
          LeagueAdminSection(admins: detail.admins),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/competition_entity.dart';
import '../../domain/entities/league_card_status.dart';

class MyLeagueCard extends StatelessWidget {
  const MyLeagueCard({
    required this.competition,
    required this.onTap,
    super.key,
  });

  final CompetitionEntity competition;
  final VoidCallback onTap;

  static const double _teamsCircleSize = 36;

  @override
  Widget build(BuildContext context) {
    final c = competition;
    final textTheme = Theme.of(context).textTheme;
    final maxP = c.maxParticipants;
    final teamCount = c.teamCount;

    return Material(
      color: DashboardColors.bgCard,
      borderRadius: BorderRadius.circular(AppRadius.cardHero),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (c.bannerUrl != null && c.bannerUrl!.isNotEmpty)
                    Positioned.fill(
                      child: Image.network(
                        c.bannerUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          AppAssets.gamingHeroPlaceholder,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: Image.asset(
                        AppAssets.gamingHeroPlaceholder,
                        fit: BoxFit.cover,
                      ),
                    ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: AppSpacing.sm,
                    left: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.42),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(
                        _heroBadgeLabel(c),
                        style: textTheme.labelSmall?.copyWith(
                          color: DashboardColors.textPrimary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      c.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleLarge?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 16,
                          color: DashboardColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            _seasonSubtitleLine(c),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall?.copyWith(
                              color: DashboardColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TEAMS',
                                style: textTheme.labelSmall?.copyWith(
                                  color: DashboardColors.textSecondary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                '$teamCount/$maxP',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: DashboardColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: _teamsCircleSize,
                          height: _teamsCircleSize,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: DashboardColors.bgSurface,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$maxP',
                            style: textTheme.labelMedium?.copyWith(
                              color: DashboardColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: DashboardColors.textPrimary),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Center(
                          child: Text(
                            'View Details',
                            style: textTheme.titleSmall?.copyWith(
                              color: DashboardColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _heroBadgeLabel(CompetitionEntity c) {
  if (c.maxParticipants > 0 && c.teamCount >= c.maxParticipants) {
    return 'FULL';
  }
  switch (c.status) {
    case LeagueCardStatus.live:
      return 'LIVE';
    case LeagueCardStatus.upcoming:
      return 'UPCOMING';
    case LeagueCardStatus.private:
      return 'PRIVATE';
  }
}

String _seasonSubtitleLine(CompetitionEntity c) {
  final m = c.matchdayLabel.trim();
  if (m.isEmpty || m == 'Season') {
    return 'Active Season';
  }
  return 'Active Season • $m';
}

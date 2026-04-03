import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import 'home_hero_background.dart';
import 'home_hero_status_bar.dart';

class HomeHeroMatchCard extends StatelessWidget {
  const HomeHeroMatchCard({
    required this.leagueChip,
    required this.contextLabel,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.minute,
    this.isLive = true,
    this.kickoffLabel = '',
    this.bannerImageUrl,
    this.compact = false,
    this.onTap,
    super.key,
  });

  final String leagueChip;
  final String contextLabel;
  final String? bannerImageUrl;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final int minute;
  final bool isLive;
  final String kickoffLabel;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 220.0 : 280.0;
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            HomeHeroBackground(bannerUrl: bannerImageUrl),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.75),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeroStatusBar(
                    isLive: isLive,
                    leagueChip: leagueChip,
                    liveMinute: minute,
                    compact: compact,
                  ),
                  const Spacer(),
                  if (!compact && contextLabel.isNotEmpty)
                    Text(
                      contextLabel,
                      style: TextStyle(
                        color: DashboardColors.textSecondary.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  if (!compact && contextLabel.isNotEmpty) const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _TeamSide(
                          name: homeTeam,
                          align: TextAlign.left,
                        ),
                      ),
                      Column(
                        children: [
                          if (isLive)
                            Text(
                              '$homeScore - $awayScore',
                              style: TextStyle(
                                color: DashboardColors.textPrimary,
                                fontSize: compact ? 28 : 36,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          else
                            Text(
                              'vs',
                              style: TextStyle(
                                color: DashboardColors.textPrimary,
                                fontSize: compact ? 22 : 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          Text(
                            isLive ? '$minute\'' : kickoffLabel,
                            style: const TextStyle(
                              color: DashboardColors.accentNeon,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: _TeamSide(
                          name: awayTeam,
                          align: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: AppSpacing.md,
              top: 0,
              bottom: 0,
              child: Center(
                child: Icon(
                  isLive ? Icons.play_circle_fill : Icons.event,
                  size: compact ? 48 : 56,
                  color: DashboardColors.textPrimary.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: card,
      ),
    );
  }
}

class _TeamSide extends StatelessWidget {
  const _TeamSide({
    required this.name,
    required this.align,
  });

  final String name;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align == TextAlign.left
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.shield,
          color: DashboardColors.textSecondary,
          size: 28,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          name,
          textAlign: align,
          style: const TextStyle(
            color: DashboardColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

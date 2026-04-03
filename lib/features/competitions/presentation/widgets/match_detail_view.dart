import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/live_match_detail_entity.dart';
import 'manage_league_event_log.dart';

/// Read-only event list (no delete) — reuses log row styling via [ManageLeagueEventLog] with no-op delete.
class MatchDetailView extends StatelessWidget {
  const MatchDetailView({required this.detail, super.key});

  final LiveMatchDetailEntity detail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (detail.isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: DashboardColors.accentGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: DashboardColors.accentGreen, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        detail.statusLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: DashboardColors.accentNeon,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  detail.statusLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
                ),
              const SizedBox(width: AppSpacing.md),
              Text(
                detail.venueLine,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
              ),
            ],
          ),
          // Kickoff / elapsed timestamps hidden — match clock not tracked accurately yet.
          const SizedBox(height: AppSpacing.lg),
          // Text(
          //   detail.matchTitle,
          //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //         color: DashboardColors.textPrimary,
          //         fontWeight: FontWeight.w800,
          //       ),
          // ),
          // const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                detail.homeName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  '${detail.homeScore}  —  ${detail.awayScore}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                detail.awayName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Streaming live — scores & events update automatically',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
          ),
          if (detail.streamLinks.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final l in detail.streamLinks)
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final uri = Uri.tryParse(l.url);
                      if (uri == null) return;
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    },
                    icon: const Icon(Icons.live_tv_outlined),
                    label: Text(l.label),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          ManageLeagueEventLog(
            events: detail.recentEvents,
            readOnly: true,
            showViewAll: false,
          ),
        ],
      ),
    );
  }
}

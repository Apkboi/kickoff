import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../models/league_format_ui.dart';
import '../controllers/create_league_state.dart';
import 'create_league_preview_banner.dart';
import 'create_league_preview_elite_box.dart';

class CreateLeaguePreviewCard extends StatelessWidget {
  const CreateLeaguePreviewCard({required this.state, super.key});

  final CreateLeagueState state;

  String _formatEnd(DateTime e) {
    final y = e.year.toString().padLeft(4, '0');
    final m = e.month.toString().padLeft(2, '0');
    final d = e.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: DashboardColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVE PREVIEW',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: DashboardColors.textSecondary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CreateLeaguePreviewBanner(bannerUrl: state.bannerUrl),
                ),
                Positioned(
                  top: AppSpacing.sm,
                  left: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: DashboardColors.accentGreen,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: const Text(
                      '• LIVE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (state.logoUrl != null && state.logoUrl!.trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: ClipOval(
                    child: Image.network(
                      state.logoUrl!.trim(),
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 36,
                        height: 36,
                        color: DashboardColors.bgSurface,
                        alignment: Alignment.center,
                        child: const Icon(Icons.shield, size: 18, color: DashboardColors.textSecondary),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  state.previewTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${state.sport.toUpperCase()} • ${LeagueFormatUi.previewLabel(state.format)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DashboardColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Players ${state.playingParticipantCount}/${state.participantCap}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: DashboardColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (state.prizePool != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Prize pool ${state.prizePool}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: DashboardColors.accentGreen,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            state.endDate == null ? 'Starts Oct 24' : 'Ends ${_formatEnd(state.endDate!)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: DashboardColors.textSecondary,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: List.generate(
              4,
              (i) => Align(
                widthFactor: i == 0 ? 1 : 0.7,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: DashboardColors.bgSurface,
                  child: Icon(Icons.person, size: 16, color: DashboardColors.accentGreen.withValues(alpha: 0.8)),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: DashboardColors.accentGreen,
                side: const BorderSide(color: DashboardColors.accentGreen),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
              child: const Text('VIEW DETAILS'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CreateLeaguePreviewEliteBox(participantTarget: state.participantTarget),
        ],
      ),
    );
  }
}

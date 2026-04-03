import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/match_prediction_view_entity.dart';

class MatchPredictionLeaderboard extends StatelessWidget {
  const MatchPredictionLeaderboard({required this.entries, super.key});

  final List<PredictionLeaderboardEntryEntity> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Text(
        'No points yet — be the first to predict correctly.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
      );
    }
    return Column(
      children: [
        for (final e in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  child: Text(
                    '${e.rank}',
                    style: const TextStyle(
                      color: DashboardColors.accentNeon,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: DashboardColors.bgSurface,
                  backgroundImage:
                      e.photoUrl != null && e.photoUrl!.isNotEmpty ? NetworkImage(e.photoUrl!) : null,
                  child: e.photoUrl == null || e.photoUrl!.isEmpty
                      ? const Icon(Icons.person, size: 18, color: DashboardColors.textSecondary)
                      : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    e.displayName,
                    style: const TextStyle(
                      color: DashboardColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${e.totalPoints} pts',
                  style: const TextStyle(
                    color: DashboardColors.accentGreen,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

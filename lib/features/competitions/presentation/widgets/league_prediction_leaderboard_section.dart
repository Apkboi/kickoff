import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../../domain/entities/match_prediction_view_entity.dart';
import '../../domain/usecases/watch_league_prediction_leaderboard_usecase.dart';
import 'match_prediction_leaderboard.dart';

/// Full-league prediction points (same `predictionScores` as match detail).
class LeaguePredictionLeaderboardSection extends StatefulWidget {
  const LeaguePredictionLeaderboardSection({required this.competitionId, super.key});

  final String competitionId;

  @override
  State<LeaguePredictionLeaderboardSection> createState() => _LeaguePredictionLeaderboardSectionState();
}

class _LeaguePredictionLeaderboardSectionState extends State<LeaguePredictionLeaderboardSection> {
  int _retryKey = 0;

  @override
  Widget build(BuildContext context) {
    final watch = getIt<WatchLeaguePredictionLeaderboardUseCase>();
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
            'Prediction leaderboard',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: DashboardColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '3 points per exact score. Open any match below to enter your pick before kickoff (−3 min) in this tournament.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          StreamBuilder<List<PredictionLeaderboardEntryEntity>>(
            key: ValueKey(_retryKey),
            stream: watch(
              WatchLeaguePredictionLeaderboardParams(leagueId: widget.competitionId),
            ),
            builder: (context, snap) {
              if (snap.hasError) {
                return RetryView(
                  message: snap.error.toString(),
                  onRetry: () => setState(() => _retryKey++),
                );
              }
              if (!snap.hasData) {
                return const LoadingShimmer();
              }
              return MatchPredictionLeaderboard(entries: snap.data!);
            },
          ),
        ],
      ),
    );
  }
}

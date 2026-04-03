import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../controllers/match_prediction_bloc.dart';
import '../controllers/match_prediction_event.dart';
import '../controllers/match_prediction_state.dart';
import 'match_prediction_inputs_section.dart';
import 'match_prediction_leaderboard.dart';
import 'match_prediction_your_pick_card.dart';

/// Score prediction until −3 min before kickoff; exact score = 3 tournament points.
class MatchPredictionPanel extends StatefulWidget {
  const MatchPredictionPanel({super.key});

  @override
  State<MatchPredictionPanel> createState() => _MatchPredictionPanelState();
}

class _MatchPredictionPanelState extends State<MatchPredictionPanel> {
  final _homeCtrl = TextEditingController();
  final _awayCtrl = TextEditingController();

  /// If false, controllers sync from Firestore; true after "Change" until save succeeds.
  bool _skipServerTextSync = false;
  bool _pendingSave = false;
  bool _submitting = false;
  bool _showSuccess = false;
  int? _lastSubmittedHome;
  int? _lastSubmittedAway;
  @override
  void dispose() {
    _homeCtrl.dispose();
    _awayCtrl.dispose();
    super.dispose();
  }

  void _onSaveFeedback(MatchPredictionReady state) {
    if (state.actionError != null && _pendingSave) {
      setState(() {
        _pendingSave = false;
        _submitting = false;
      });
      return;
    }
    if (_pendingSave && state.data.userPrediction != null) {
      final p = state.data.userPrediction!;
      if (_lastSubmittedHome != null &&
          _lastSubmittedAway != null &&
          p.homePredicted == _lastSubmittedHome &&
          p.awayPredicted == _lastSubmittedAway) {
        setState(() {
          _pendingSave = false;
          _submitting = false;
          _showSuccess = true;
          _skipServerTextSync = false;
        });
      }
    }
  }

  void _syncControllersFromServer(MatchPredictionReady state) {
    final pred = state.data.userPrediction;
    if (pred == null) return;
    if (_skipServerTextSync) return;
    _homeCtrl.text = '${pred.homePredicted}';
    _awayCtrl.text = '${pred.awayPredicted}';
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchPredictionBloc, MatchPredictionState>(
      listenWhen: (p, c) => c is MatchPredictionReady,
      listener: (context, state) {
        if (state is! MatchPredictionReady) return;
        _syncControllersFromServer(state);
        _onSaveFeedback(state);
        if (mounted) setState(() {});
      },
      builder: (context, state) {
        if (state is MatchPredictionLoading || state is MatchPredictionInitial) {
          return const Padding(padding: EdgeInsets.only(top: AppSpacing.md), child: LoadingShimmer());
        }
        if (state is MatchPredictionError) {
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Text(state.message, style: const TextStyle(color: DashboardColors.textSecondary)),
          );
        }
        if (state is! MatchPredictionReady) return const SizedBox.shrink();
        final d = state.data;
        final err = state.actionError;

        final hasSavedPrediction = d.userPrediction != null;
        final viewOnlyWithPrediction =
            hasSavedPrediction && !_skipServerTextSync && d.isPredictionWindowOpen;

        final canEditScores = d.isPredictionWindowOpen &&
            d.isSignedIn &&
            d.kickoffAt != null &&
            (!hasSavedPrediction || _skipServerTextSync) &&
            !_submitting;

        final fieldsReadOnly = !canEditScores || _submitting;

        return Padding(
          padding: const EdgeInsets.only(top: AppSpacing.lg),
          child: Container(
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
                  'Predict the score',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You can change your pick until 3 minutes before kickoff. Each exact score earns 3 points in this tournament.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.md),
                if (d.userPrediction != null) ...[
                  MatchPredictionYourPickCard(prediction: d.userPrediction!),
                  const SizedBox(height: AppSpacing.md),
                ],
                if (!d.isSignedIn)
                  TextButton(
                    onPressed: () => context.push(AppRoutes.signIn),
                    child: const Text('Sign in to predict'),
                  )
                else if (d.kickoffAt == null)
                  const Text('Kickoff time not set yet.', style: TextStyle(color: DashboardColors.textSecondary))
                else if (!d.isPredictionWindowOpen)
                  Text(
                    {'live', 'finished', 'ft'}.contains(d.matchStatusRaw)
                        ? 'Predictions are closed for this match.'
                        : 'Predictions closed (window ends 3 minutes before kickoff).',
                    style: const TextStyle(color: DashboardColors.textSecondary),
                  )
                else
                  MatchPredictionInputsSection(
                    data: d,
                    actionError: err,
                    homeCtrl: _homeCtrl,
                    awayCtrl: _awayCtrl,
                    fieldsReadOnly: fieldsReadOnly,
                    submitting: _submitting,
                    showSuccess: _showSuccess,
                    showChangeButton: viewOnlyWithPrediction,
                    onSubmit: () => _submit(context),
                    onChangePressed: () => setState(() {
                      _skipServerTextSync = true;
                      _showSuccess = false;
                    }),
                  ),
                if (d.userPrediction != null && d.userPrediction!.pointsAwarded > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '+${d.userPrediction!.pointsAwarded} points — your prediction matched the final score.',
                    style: const TextStyle(color: DashboardColors.accentGreen, fontWeight: FontWeight.w600),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Tournament leaderboard',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.sm),
                MatchPredictionLeaderboard(entries: d.leaderboard),
              ],
            ),
          ),
        );
      },
    );
  }
  void _submit(BuildContext context) {
    final h = int.tryParse(_homeCtrl.text.trim());
    final a = int.tryParse(_awayCtrl.text.trim());
    if (h == null || a == null) return;
    setState(() {
      _lastSubmittedHome = h;
      _lastSubmittedAway = a;
      _pendingSave = true;
      _submitting = true;
      _showSuccess = false;
    });
    context.read<MatchPredictionBloc>().add(MatchPredictionSubmitted(homePredicted: h, awayPredicted: a));
  }
}

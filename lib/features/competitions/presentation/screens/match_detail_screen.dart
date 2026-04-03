import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../controllers/match_detail_bloc.dart';
import '../controllers/match_detail_event.dart';
import '../controllers/match_detail_state.dart';
import '../controllers/match_prediction_bloc.dart';
import '../controllers/match_prediction_event.dart';
import '../widgets/match_detail_view.dart';
import '../widgets/match_prediction_panel.dart';

class MatchDetailScreen extends StatefulWidget {
  const MatchDetailScreen({
    required this.competitionId,
    required this.matchId,
    super.key,
  });

  final String competitionId;
  final String matchId;

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  void _dispatchPredictionWatch() {
    if (!mounted) return;
    final auth = context.read<AuthBloc>().state;
    final uid = auth is AuthLoaded ? auth.user.id : null;
    context.read<MatchPredictionBloc>().add(
          MatchPredictionStarted(
            leagueId: widget.competitionId,
            matchId: widget.matchId,
            userId: uid,
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _dispatchPredictionWatch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        if (current is! AuthLoaded) return false;
        if (previous is AuthLoaded) {
          return previous.user.id != current.user.id;
        }
        return true;
      },
      listener: (context, state) {
        if (state is AuthLoaded) {
          _dispatchPredictionWatch();
        }
      },
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                    ),
                    Expanded(
                      child: Text(
                        'Match',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: DashboardColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    BlocBuilder<MatchDetailBloc, MatchDetailState>(
                      buildWhen: (a, b) => a is MatchDetailLoaded || b is MatchDetailLoaded,
                      builder: (context, state) {
                        if (state is MatchDetailLoaded && state.detail.isLive) {
                          return Text(
                            '● LIVE',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: DashboardColors.accentGreen,
                                  fontWeight: FontWeight.w800,
                                ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<MatchDetailBloc, MatchDetailState>(
                  builder: (context, state) {
                    if (state is MatchDetailLoading || state is MatchDetailInitial) {
                      return const LoadingShimmer();
                    }
                    if (state is MatchDetailError) {
                      return RetryView(
                        message: state.message,
                        onRetry: () => context.read<MatchDetailBloc>().add(
                              MatchDetailWatchStarted(
                                competitionId: widget.competitionId,
                                matchId: widget.matchId,
                              ),
                            ),
                      );
                    }
                    if (state is! MatchDetailLoaded) {
                      return const SizedBox.shrink();
                    }
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MatchDetailView(detail: state.detail),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: MatchPredictionPanel(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

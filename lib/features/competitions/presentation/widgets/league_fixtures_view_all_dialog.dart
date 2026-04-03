import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../../domain/usecases/get_league_fixtures_page_usecase.dart';
import '../controllers/league_fixtures_pagination_bloc.dart';
import '../controllers/league_fixtures_pagination_event.dart';
import '../controllers/league_fixtures_pagination_state.dart';

class LeagueFixturesViewAllDialog extends StatelessWidget {
  const LeagueFixturesViewAllDialog({
    required this.competitionId,
    super.key,
  });

  final String competitionId;

  static const int _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeagueFixturesPaginationBloc(getIt<GetLeagueFixturesPageUseCase>())..add(
        LeagueFixturesPaginationStarted(
          competitionId: competitionId,
          pageSize: _pageSize,
        ),
      ),
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, minWidth: 320, maxHeight: 700),
          child: Column(
            children: [
              _Header(competitionId: competitionId),
              Expanded(
                child: BlocBuilder<LeagueFixturesPaginationBloc, LeagueFixturesPaginationState>(
                  builder: (context, state) {
                    if (state is LeagueFixturesPaginationLoading) {
                      return const LoadingShimmer();
                    }
                    if (state is LeagueFixturesPaginationError) {
                      return RetryView(
                        message: state.message,
                        onRetry: () {
                          context.read<LeagueFixturesPaginationBloc>().add(
                                LeagueFixturesPaginationStarted(
                                  competitionId: competitionId,
                                  pageSize: _pageSize,
                                ),
                              );
                        },
                      );
                    }
                    if (state is! LeagueFixturesPaginationLoaded) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.fixtures.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            itemBuilder: (context, index) {
                              final f = state.fixtures[index];
                              return _FixtureRow(
                                fixture: f,
                                onTap: () => context.push(AppRoutes.matchDetailPath(competitionId, f.matchId)),
                              );
                            },
                          ),
                        ),
                        if (state.nextCursor != null)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
                            child: SizedBox(
                              width: double.infinity,
                              child: FilledButton.tonal(
                                onPressed: state.isLoadingMore
                                    ? null
                                    : () => context.read<LeagueFixturesPaginationBloc>().add(
                                          const LeagueFixturesPaginationNextRequested(),
                                        ),
                                child: state.isLoadingMore
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      )
                                    : const Text('Load more'),
                              ),
                            ),
                          ),
                      ],
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

class _Header extends StatelessWidget {
  const _Header({required this.competitionId});

  final String competitionId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All matches & fixtures',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: DashboardColors.textPrimary,
                ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class _FixtureRow extends StatelessWidget {
  const _FixtureRow({
    required this.fixture,
    required this.onTap,
  });

  final LeagueFixtureSummaryEntity fixture;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Row(
            children: [
              const Icon(Icons.sports_soccer, color: DashboardColors.accentGreen),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fixture.headline,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      fixture.statusLine,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: DashboardColors.textSecondary.withValues(alpha: 0.6)),
            ],
          ),
        ),
      ),
    );
  }
}


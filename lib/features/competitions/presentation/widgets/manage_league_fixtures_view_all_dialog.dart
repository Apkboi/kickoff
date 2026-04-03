import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../../domain/usecases/get_league_fixtures_page_usecase.dart';
import '../controllers/league_fixtures_pagination_bloc.dart';
import '../controllers/league_fixtures_pagination_event.dart';
import '../controllers/league_fixtures_pagination_state.dart';
import 'manage_league_fixture_row.dart';

class ManageLeagueFixturesViewAllDialog extends StatelessWidget {
  const ManageLeagueFixturesViewAllDialog({
    required this.competitionId,
    required this.selectedMatchId,
    required this.onMatchSelected,
    super.key,
  });

  final String competitionId;
  final String selectedMatchId;
  final ValueChanged<String> onMatchSelected;

  static const int _pageSize = 10;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LeagueFixturesPaginationBloc(getIt<GetLeagueFixturesPageUseCase>())..add(
        LeagueFixturesPaginationStarted(competitionId: competitionId, pageSize: _pageSize),
      ),
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, minWidth: 320, maxHeight: 700),
          child: Column(
            children: [
              Padding(
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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
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
                                LeagueFixturesPaginationStarted(competitionId: competitionId, pageSize: _pageSize),
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
                              return ManageLeagueFixtureRow(
                                fixture: f,
                                isSelected: f.matchId == selectedMatchId,
                                onTap: () {
                                  onMatchSelected(f.matchId);
                                  Navigator.of(context).pop();
                                },
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


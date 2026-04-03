import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import '../../domain/league_detail_admin.dart';
import '../controllers/competition_detail_bloc.dart';
import '../controllers/competition_detail_event.dart';
import '../controllers/competition_detail_state.dart';
import '../widgets/competition_detail_desktop_body.dart';
import '../widgets/league_admin_section.dart';
import '../widgets/league_detail_hero.dart';
import '../widgets/league_detail_tab_content.dart';
import '../widgets/league_prediction_leaderboard_section.dart';
import '../widgets/league_spectator_matches_section.dart';

class CompetitionDetailScreen extends StatelessWidget {
  const CompetitionDetailScreen({required this.competitionId, super.key});

  final String competitionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompetitionDetailBloc, CompetitionDetailState>(
      builder: (context, state) {
        if (state is CompetitionDetailLoading || state is CompetitionDetailInitial) {
          return Scaffold(
            backgroundColor: DashboardColors.bgPrimary,
            body: const LoadingShimmer(),
          );
        }
        if (state is CompetitionDetailError) {
          return Scaffold(
            backgroundColor: DashboardColors.bgPrimary,
            body: RetryView(
              message: state.message,
              onRetry: () => context.read<CompetitionDetailBloc>().add(
                    CompetitionDetailRequested(competitionId),
                  ),
            ),
          );
        }
        if (state is! CompetitionDetailLoaded) {
          return const SizedBox.shrink();
        }
        final detail = state.detail;

        if (Responsive.isDesktop(context)) {
          return Scaffold(
            backgroundColor: DashboardColors.bgPrimary,
            body: SafeArea(
              child: SingleChildScrollView(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    final isAdmin = authState is AuthLoaded &&
                        detail.isViewerAdmin(
                          userId: authState.user.id,
                          authenticated: authState.user.isAuthenticated,
                        );
                    return CompetitionDetailDesktopBody(
                      detail: detail,
                      standings: state.standings,
                      competitionId: competitionId,
                      onBack: () => context.pop(),
                      onManageLeague:
                          isAdmin ? () => context.push(AppRoutes.manageLeaguePath(detail.id)) : null,
                    );
                  },
                ),
              ),
            ),
          );
        }

        final scroll = SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            Responsive.isMobile(context) ? 100 : AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(
                      detail.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: DashboardColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              LeagueDetailHero(detail: detail),
              const SizedBox(height: AppSpacing.md),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final isAdmin = authState is AuthLoaded &&
                      detail.isViewerAdmin(
                        userId: authState.user.id,
                        authenticated: authState.user.isAuthenticated,
                      );
                  if (!isAdmin) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.icon(
                        onPressed: () => context.push(AppRoutes.manageLeaguePath(detail.id)),
                        icon: const Icon(Icons.tune_outlined),
                        label: const Text('Manage tournament'),
                        style: FilledButton.styleFrom(
                          backgroundColor: DashboardColors.accentGreen,
                          foregroundColor: DashboardColors.textOnAccent,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              LeaguePredictionLeaderboardSection(competitionId: detail.id),
              const SizedBox(height: AppSpacing.lg),
              LeagueSpectatorMatchesSection(
                competitionId: detail.id,
                fixtures: detail.fixtures,
              ),
              const SizedBox(height: AppSpacing.lg),
              LeagueDetailTabContent(detail: detail, standings: state.standings),
              const SizedBox(height: AppSpacing.lg),
              LeagueAdminSection(admins: detail.admins),
            ],
          ),
        );

        final tabletOrMobile = Responsive.isTablet(context)
            ? Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: scroll,
                ),
              )
            : scroll;

        return Scaffold(
          backgroundColor: DashboardColors.bgPrimary,
          body: Responsive.isMobile(context)
              ? Stack(
                  children: [
                    tabletOrMobile,
                    Positioned(
                      right: AppSpacing.md,
                      bottom: AppSpacing.md,
                      child: FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: DashboardColors.accentGreen,
                        foregroundColor: DashboardColors.textOnAccent,
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                )
              : SafeArea(child: tabletOrMobile),
        );
      },
    );
  }
}

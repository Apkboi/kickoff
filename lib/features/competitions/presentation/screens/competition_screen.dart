import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../controllers/competition_bloc.dart';
import '../controllers/competition_event.dart';
import '../controllers/competition_state.dart';
import '../widgets/my_league_card.dart';
import '../widgets/my_leagues_mobile_header.dart';
import '../widgets/my_leagues_stat_cards.dart';

class CompetitionScreen extends StatefulWidget {
  const CompetitionScreen({super.key});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<CompetitionBloc>();
      if (bloc.state is! CompetitionLoaded) {
        bloc.add(const CompetitionsRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompetitionBloc, CompetitionState>(
      builder: (context, state) {
        if (state is CompetitionLoading || state is CompetitionInitial) {
          return const LoadingShimmer();
        }
        if (state is CompetitionError) {
          return RetryView(
            message: state.message,
            onRetry: () => context.read<CompetitionBloc>().add(const CompetitionsRequested()),
          );
        }
        if (state is! CompetitionLoaded) {
          return const SizedBox.shrink();
        }
        final list = state.competitions;
        final padding = EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? AppSpacing.md : AppSpacing.lg,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Responsive.isMobile(context)) ...[
              Padding(padding: padding, child: const MyLeaguesMobileHeader()),
            ],
            Padding(
              padding: padding,
              child: Text(
                'My Leagues',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: DashboardColors.accentGreen,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: padding,
              child: Text(
                'Manage your active competitions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textSecondary),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: padding,
              child: const MyLeaguesStatCards(activeCount: '12', rankLabel: '#4'),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ListView.separated(
                padding: padding.copyWith(bottom: AppSpacing.xl),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final c = list[index];
                  return MyLeagueCard(
                    key: ValueKey(c.id),
                    competition: c,
                    onTap: () => context.push(AppRoutes.competitionDetailPath(c.id)),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';
import '../widgets/manage_league_back_bar.dart';
import '../widgets/manage_league_desktop_body.dart';
import '../widgets/manage_league_mobile_body.dart';

class ManageLeagueScreen extends StatelessWidget {
  const ManageLeagueScreen({required this.competitionId, super.key});

  final String competitionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageLeagueBloc, ManageLeagueState>(
      builder: (context, state) {
        if (state is ManageLeagueLoading || state is ManageLeagueInitial) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ManageLeagueBackBar(),
                const Expanded(child: LoadingShimmer()),
              ],
            ),
          );
        }
        if (state is ManageLeagueError) {
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ManageLeagueBackBar(),
                Expanded(
                  child: RetryView(
                    message: state.message,
                    onRetry: () => context.read<ManageLeagueBloc>().add(ManageLeagueStarted(competitionId)),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is ManageLeagueAccessDenied) {
          
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ManageLeagueBackBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'You do not have permission to manage this league.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        FilledButton(
                          onPressed: () => context.pop(),
                          child: const Text('Go back'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (state is! ManageLeagueLoaded) {
          return const SizedBox.shrink();
        }
        Widget body;
        if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
          body = Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
            child: ManageLeagueDesktopBody(
              competitionId: competitionId,
            ),
          );
        } else {
          body = ManageLeagueMobileBody(
            competitionId: competitionId,
          );
        }
        return SizedBox.expand(
          child: Scaffold(
            body: Column(
              
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ManageLeagueBackBar(),
                Expanded(child: body),
              ],
            ),
          ),
        );
      },
    );
  }
}

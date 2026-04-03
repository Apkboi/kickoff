import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/responsive.dart';
import '../controllers/create_league_bloc.dart';
import '../controllers/create_league_state.dart';
import '../widgets/create_league_desktop_layout.dart';
import '../widgets/create_league_mobile_layout.dart';

class CreateLeagueScreen extends StatelessWidget {
  const CreateLeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CreateLeagueBloc>(),
      child: BlocListener<CreateLeagueBloc, CreateLeagueState>(
        listenWhen: (p, c) =>
            (c.publishSuccessLeagueId != null &&
                c.publishSuccessLeagueId != p.publishSuccessLeagueId) ||
            (c.publishError != null && c.publishError != p.publishError),
        listener: (context, state) {
          if (state.publishSuccessLeagueId != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('League published. It will appear on Explore.'),
              ),
            );
            context.go(AppRoutes.explore);
          }
          if (state.publishError != null && state.publishError!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.publishError!)));
          }
        },
        child: BlocBuilder<CreateLeagueBloc, CreateLeagueState>(
          builder: (context, state) {
            final width = MediaQuery.sizeOf(context).width;
            final useWideLayout =
                Responsive.isDesktop(context) ||
                (Responsive.isTablet(context) && width >= 900);

            final content = useWideLayout
                ? CreateLeagueDesktopLayout(state: state)
                : CreateLeagueMobileLayout(state: state);

            if (Responsive.isMobile(context)) {
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: content,
                ),
              );
            }
            return Scaffold(body: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: content,
            ));
          },
        ),
      ),
    );
  }
}

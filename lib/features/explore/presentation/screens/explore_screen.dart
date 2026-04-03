import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../controllers/explore_bloc.dart';
import '../controllers/explore_event.dart';
import '../controllers/explore_state.dart';
import '../widgets/explore_desktop_view.dart';
import '../widgets/explore_mobile_view.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreBloc, ExploreState>(
      builder: (context, state) {
        if (state is ExploreLoading || state is ExploreInitial) {
          return const LoadingShimmer();
        }
        if (state is ExploreError) {
          return RetryView(
            message: state.message,
            onRetry: () => context.read<ExploreBloc>().add(const ExploreStarted()),
          );
        }
        if (state is! ExploreLoaded) {
          return const SizedBox.shrink();
        }
        final loaded = state;
        if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ExploreDesktopView(loaded: loaded),
          );
        }
        return ExploreMobileView(loaded: loaded);
      },
    );
  }
}

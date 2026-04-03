import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/loading_shimmer.dart';
import '../../../../shared/widgets/retry_view.dart';
import '../controllers/profile_bloc.dart';
import '../controllers/profile_event.dart';
import '../controllers/profile_state.dart';
import '../widgets/profile_desktop_view.dart';
import '../widgets/profile_mobile_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.profileUserId, super.key});

  /// When set, shows that user's public profile (read-only for others).
  final String? profileUserId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileBloc>().add(
            ProfileRequested(forUserId: widget.profileUserId),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const LoadingShimmer();
        }
        if (state is ProfileError) {
          return RetryView(
            message: state.message,
            onRetry: () => context.read<ProfileBloc>().add(
                  ProfileRequested(forUserId: widget.profileUserId),
                ),
          );
        }
        if (state is! ProfileLoaded) {
          return const SizedBox.shrink();
        }
        final profile = state.profile;
        final isOwn = state.isOwnProfile;
        if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: ProfileDesktopView(profile: profile, isOwnProfile: isOwn),
          );
        }
        return ProfileMobileView(profile: profile, isOwnProfile: isOwn);
      },
    );
  }
}

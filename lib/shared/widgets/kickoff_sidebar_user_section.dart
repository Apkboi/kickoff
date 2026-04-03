import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_radius.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/theme/dashboard_colors.dart';
import '../../features/auth/presentation/controllers/auth_bloc.dart';
import '../../features/auth/presentation/controllers/auth_event.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';

/// Desktop sidebar footer: signed-in user info + log out.
class KickoffSidebarUserSection extends StatelessWidget {
  const KickoffSidebarUserSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) =>
          c is AuthLoaded || c is AuthLoading || c is AuthInitial,
      builder: (context, state) {
        if (state is AuthLoaded && state.user.isAuthenticated) {
          final u = state.user;
          final hasPhoto = u.photoUrl != null && u.photoUrl!.isNotEmpty;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: DashboardColors.bgCard,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: DashboardColors.borderSubtle),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: DashboardColors.bgSurface,
                      foregroundImage: hasPhoto ? NetworkImage(u.photoUrl!) : null,
                      onForegroundImageError: hasPhoto ? (_, __) {} : null,
                      child: const Icon(Icons.person, color: DashboardColors.textSecondary),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            u.displayLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: DashboardColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (u.email.isNotEmpty)
                            Text(
                              u.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: DashboardColors.textSecondary,
                                  ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Profile',
                      onPressed: () => context.go(AppRoutes.profile),
                      icon: const Icon(Icons.person_outline, color: DashboardColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () =>
                    context.read<AuthBloc>().add(const SignOutRequested()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: DashboardColors.textSecondary,
                  side: const BorderSide(color: DashboardColors.borderSubtle),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                ),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Log out'),
              ),
            ],
          );
        }
        if (state is AuthLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: DashboardColors.accentGreen,
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

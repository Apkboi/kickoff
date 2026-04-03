import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../auth/presentation/controllers/auth_bloc.dart';
import '../../../auth/presentation/controllers/auth_state.dart';
import 'home_dashboard_nav.dart';
import '../../../../shared/widgets/profile_avatar_chip.dart';

class HomeMobileHeader extends StatelessWidget {
  const HomeMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final name = authState is AuthLoaded ? authState.user.displayLabel : 'Player';
        final photo = authState is AuthLoaded ? authState.user.photoUrl : null;
        return Row(
          children: [
            ProfileAvatarChip(
              photoUrl: photo,
              radius: 26,
              onTap: () => HomeDashboardNav.openEditProfile(context),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DashboardColors.textSecondary,
                        ),
                  ),
                  Text(
                    'Hi, $name!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: DashboardColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: DashboardColors.bgCard,
                foregroundColor: DashboardColors.accentNeon,
              ),
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        );
      },
    );
  }
}

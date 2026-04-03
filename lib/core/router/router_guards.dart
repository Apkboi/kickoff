import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/controllers/auth_bloc.dart';
import '../../features/auth/presentation/controllers/auth_state.dart';
import '../constants/app_routes.dart';
import '../di/injection.dart';

abstract final class RouterGuards {
  static bool _isProtected(String location) {
    if (location == AppRoutes.competitions || location.startsWith('${AppRoutes.competitions}/')) {
      return true;
    }
    const protected = <String>{
      AppRoutes.home,
      AppRoutes.createLeague,
      AppRoutes.explore,
      AppRoutes.schedule,
      AppRoutes.profile,
    };
    return protected.contains(location);
  }

  static String? authGuard(BuildContext context, GoRouterState state) {
    final AuthState authState = getIt<AuthBloc>().state;
    final location = state.matchedLocation;
    final isSigningIn = location == AppRoutes.signIn;
    final isSigningUp = location == AppRoutes.signUp;
    final isProtected = _isProtected(location);

    if (authState is AuthLoaded && authState.user.isAuthenticated) {
      if (isSigningIn || isSigningUp) {
        return AppRoutes.home;
      }
      return null;
    }

    if (authState is AuthInitial || authState is AuthLoading) {
      if (isProtected) {
        return AppRoutes.signIn;
      }
      return null;
    }

    if (authState is AuthPasswordResetEmailSent) {
      if (isSigningIn || isSigningUp) {
        return null;
      }
    }

    if (authState is AuthFailure) {
      if (isSigningIn || isSigningUp) {
        return null;
      }
    }

    if (authState is AuthLoaded && !authState.user.isAuthenticated) {
      if (isSigningIn || isSigningUp) {
        return null;
      }
      return AppRoutes.signIn;
    }

    if (isSigningIn || isSigningUp) {
      return null;
    }

    return AppRoutes.signIn;
  }
}

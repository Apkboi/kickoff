import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.authBackgroundStart,
            AppColors.authBackgroundEnd,
          ],
        ),
      ),
      child: child,
    );
  }
}

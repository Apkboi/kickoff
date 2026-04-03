import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class AuthGlassCard extends StatelessWidget {
  const AuthGlassCard({
    required this.child,
    this.highlightBorder = false,
    super.key,
  });

  final Widget child;
  final bool highlightBorder;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.authGlassFill,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: highlightBorder
                  ? AppColors.authPrimary
                  : AppColors.authGlassBorder,
              width: highlightBorder ? 1.5 : 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';

class AuthBrandingHeader extends StatelessWidget {
  const AuthBrandingHeader({
    required this.headline,
    required this.subtitle,
    this.compact = false,
    this.showBrandRow = true,
    super.key,
  });

  final String headline;
  final String subtitle;
  final bool compact;
  final bool showBrandRow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBrandRow) ...[
          Row(
            children: [
              Icon(
                Icons.sports_soccer,
                color: AppColors.authPrimary,
                size: compact ? 26 : 30,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'KICK OFF',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.authPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
              ),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
        ],
        Text(
          headline,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.authForeground,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.authSubtleForeground,
              ),
        ),
      ],
    );
  }
}

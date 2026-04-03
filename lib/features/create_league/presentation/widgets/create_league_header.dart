import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class CreateLeagueHeader extends StatelessWidget {
  const CreateLeagueHeader({
    required this.compact,
    this.onPreviewTap,
    super.key,
  });

  final bool compact;
  final VoidCallback? onPreviewTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: DashboardColors.textPrimary),
        ),
        Expanded(
          child: Text(
            'Create League',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: DashboardColors.accentGreen,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        if (!compact) ...[
          _circleIcon(context, Icons.search),
          const SizedBox(width: AppSpacing.sm),
          _circleIcon(context, Icons.notifications_none),
          const SizedBox(width: AppSpacing.sm),
          _circleIcon(context, Icons.settings_outlined),
          const SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 18,
            backgroundColor: DashboardColors.bgCard,
            child: const Icon(Icons.person, color: DashboardColors.textSecondary, size: 20),
          ),
        ],
        if (compact && onPreviewTap != null)
          IconButton(
            onPressed: onPreviewTap,
            style: IconButton.styleFrom(
              backgroundColor: DashboardColors.bgCard,
              foregroundColor: DashboardColors.accentNeon,
            ),
            icon: const Icon(Icons.visibility_outlined),
            tooltip: 'Preview',
          ),
      ],
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon) {
    return Material(
      color: DashboardColors.bgCard,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: DashboardColors.textSecondary, size: 20),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/entities/league_admin_entity.dart';

class LeagueAdminSection extends StatelessWidget {
  const LeagueAdminSection({required this.admins, super.key});

  final List<LeagueAdminEntity> admins;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 18,
              decoration: BoxDecoration(
                color: DashboardColors.accentGreen,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'League Admin',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: DashboardColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = Responsive.isMobile(context);
            final crossAxisCount = isMobile ? 1 : 2;
            final cardWidth = crossAxisCount == 1
                ? constraints.maxWidth
                : (constraints.maxWidth - AppSpacing.md) / crossAxisCount;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: admins
                  .map(
                    (admin) => SizedBox(
                      width: cardWidth,
                      child: _AdminCard(admin: admin),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({required this.admin});

  final LeagueAdminEntity admin;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(
              admin.name.isNotEmpty ? admin.name[0] : '?',
              style: const TextStyle(color: DashboardColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  admin.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: DashboardColors.textPrimary,
                      ),
                ),
                Text(
                  admin.role,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: DashboardColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
            decoration: BoxDecoration(
              color: DashboardColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Text(
              admin.tag,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: DashboardColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

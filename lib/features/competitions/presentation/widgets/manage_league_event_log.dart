import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/manage_match_event_entity.dart';

class ManageLeagueEventLog extends StatelessWidget {
  const ManageLeagueEventLog({
    required this.events,
    this.onDelete,
    this.showViewAll = true,
    this.readOnly = false,
    super.key,
  });

  final List<ManageMatchEventEntity> events;
  final ValueChanged<String>? onDelete;
  final bool showViewAll;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'EVENT LOG',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: DashboardColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
            ),
            if (showViewAll)
              TextButton(
                onPressed: () {},
                child: Text(
                  'VIEW ALL',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: DashboardColors.accentGreen,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...events.map(
          (e) => _EventTile(
            event: e,
            onDelete: readOnly || onDelete == null ? null : () => onDelete!(e.id),
          ),
        ),
      ],
    );
  }
}

class _EventTile extends StatelessWidget {
  const _EventTile({required this.event, this.onDelete});

  final ManageMatchEventEntity event;
  final VoidCallback? onDelete;

  Color _iconBg() {
    return switch (event.kind) {
      ManageMatchEventKind.goal => DashboardColors.accentGreen.withValues(alpha: 0.2),
      ManageMatchEventKind.yellowCard => DashboardColors.rankGold.withValues(alpha: 0.25),
      ManageMatchEventKind.redCard => DashboardColors.liveBadge.withValues(alpha: 0.2),
      ManageMatchEventKind.substitution => DashboardColors.bgSurface,
    };
  }

  IconData _icon() {
    return switch (event.kind) {
      ManageMatchEventKind.goal => Icons.sports_soccer,
      ManageMatchEventKind.yellowCard => Icons.style,
      ManageMatchEventKind.redCard => Icons.cancel,
      ManageMatchEventKind.substitution => Icons.sync,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: DashboardColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: DashboardColors.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: _iconBg(),
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: Icon(_icon(), size: 20, color: DashboardColors.textPrimary),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: DashboardColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    event.subtitle,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (onDelete != null)
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: DashboardColors.textSecondary, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}

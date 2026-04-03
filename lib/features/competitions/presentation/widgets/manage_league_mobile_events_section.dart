import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/manage_league_snapshot_entity.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import 'manage_league_event_log.dart';
import 'manage_league_events_shimmer.dart';
import 'manage_league_mobile_quick_chips.dart';
import 'manage_league_player_picker_dialog.dart';

class ManageLeagueMobileEventsSection extends StatelessWidget {
  const ManageLeagueMobileEventsSection({
    required this.canEdit,
    required this.isEventsLoading,
    required this.snapshot,
    required this.bloc,
    super.key,
  });

  final bool canEdit;
  final bool isEventsLoading;
  final ManageLeagueSnapshotEntity snapshot;
  final ManageLeagueBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'QUICK EVENTS',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: DashboardColors.textSecondary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Opacity(
          opacity: canEdit ? 1 : 0.4,
          child: ManageLeagueMobileQuickChips(
            onCard: () async {
              final player = await showManageLeaguePlayerPickerDialog(
                context,
                title: 'Select team for yellow card',
                options: [snapshot.homeTeamName, snapshot.awayTeamName],
              );
              if (player == null || !context.mounted) return;
              bloc.add(
                ManageLeagueQuickEventAdded(
                  ManageMatchEventKind.yellowCard,
                  playerName: player,
                ),
              );
            },
            onRedCard: () async {
              final player = await showManageLeaguePlayerPickerDialog(
                context,
                title: 'Select team for red card',
                options: [snapshot.homeTeamName, snapshot.awayTeamName],
              );
              if (player == null || !context.mounted) return;
              bloc.add(
                ManageLeagueQuickEventAdded(
                  ManageMatchEventKind.redCard,
                  playerName: player,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (isEventsLoading)
          const ManageLeagueEventsShimmer()
        else
          ManageLeagueEventLog(
            events: snapshot.events,
            readOnly: !canEdit,
            onDelete: canEdit ? (id) => bloc.add(ManageLeagueEventDeleted(id)) : null,
          ),
      ],
    );
  }
}


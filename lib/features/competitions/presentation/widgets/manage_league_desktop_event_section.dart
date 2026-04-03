import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/manage_match_event_entity.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';
import 'manage_league_event_log.dart';
import 'manage_league_events_shimmer.dart';
import 'manage_league_player_picker_dialog.dart';

class ManageLeagueDesktopEventSection extends StatelessWidget {
  const ManageLeagueDesktopEventSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ManageLeagueBloc>();
    return BlocBuilder<ManageLeagueBloc, ManageLeagueState>(
      buildWhen: (a, b) => a is ManageLeagueLoaded || b is ManageLeagueLoaded,
      builder: (context, state) {
        if (state is! ManageLeagueLoaded) {
          return const SizedBox.shrink();
        }
        final snap = state.snapshot;
        final canEdit = snap.scoringEnabled;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Match Event Log',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                TextButton(
                  onPressed: canEdit ? () {} : null,
                  child: Text(
                    '+ Add Manual Event',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: canEdit ? DashboardColors.accentGreen : DashboardColors.textSecondary,
                        ),
                  ),
                ),
              ],
            ),
            if (state.isEventsLoading)
              const ManageLeagueEventsShimmer()
            else
              ManageLeagueEventLog(
                events: snap.events,
                readOnly: !canEdit,
                onDelete: canEdit ? (id) => bloc.add(ManageLeagueEventDeleted(id)) : null,
                showViewAll: false,
              ),
            const SizedBox(height: AppSpacing.lg),
            Opacity(
              opacity: canEdit ? 1 : 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _QuickDesktop(
                    label: 'YELLOW',
                    icon: Icons.style,
                    onTap: canEdit
                        ? () async {
                            final player = await showManageLeaguePlayerPickerDialog(
                              context,
                              title: 'Select team for yellow card',
                              options: [snap.homeTeamName, snap.awayTeamName],
                            );
                            if (player == null || !context.mounted) return;
                            bloc.add(
                              ManageLeagueQuickEventAdded(
                                ManageMatchEventKind.yellowCard,
                                playerName: player,
                              ),
                            );
                          }
                        : () {},
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _QuickDesktop(
                    label: 'RED',
                    icon: Icons.cancel,
                    onTap: canEdit
                        ? () async {
                            final player = await showManageLeaguePlayerPickerDialog(
                              context,
                              title: 'Select team for red card',
                              options: [snap.homeTeamName, snap.awayTeamName],
                            );
                            if (player == null || !context.mounted) return;
                            bloc.add(
                              ManageLeagueQuickEventAdded(
                                ManageMatchEventKind.redCard,
                                playerName: player,
                              ),
                            );
                          }
                        : () {},
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuickDesktop extends StatelessWidget {
  const _QuickDesktop({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

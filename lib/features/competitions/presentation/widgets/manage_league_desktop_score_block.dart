import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';
import 'manage_league_end_league_dialog.dart';
import 'manage_league_schedule_dialog.dart';
import 'manage_league_stream_link_dialog.dart';
import 'manage_league_team_score_card.dart';

class ManageLeagueDesktopScoreBlock extends StatelessWidget {
  const ManageLeagueDesktopScoreBlock({super.key});

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
        LeagueFixtureSummaryEntity? selected;
        for (final f in state.fixtures) {
          if (f.matchId == state.selectedMatchId) {
            selected = f;
            break;
          }
        }
        final showStart =
            selected != null && selected.phase == LeagueFixturePhase.scheduled && !snap.scoringEnabled;
        final selectedFixture = selected;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Score: ${snap.matchTitle}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: DashboardColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
                Text(
                  'Live — updates stream to followers',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: DashboardColors.textSecondary),
                ),
              ],
            ),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: () async {
                    final name = await showManageLeagueEndLeagueDialog(context);
                    if (!context.mounted || name == null) return;
                    bloc.add(ManageLeagueCompetitionEnded(name));
                  },
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: const Text('End league'),
                ),
              ],
            ),
            if (showStart) ...[
              const SizedBox(height: AppSpacing.md),
              FilledButton.icon(
                onPressed: () async {
                  final streamUrl = await showManageLeagueStreamLinkDialog(context);
                  if (!context.mounted || streamUrl == null) return;
                  bloc.add(ManageLeagueMatchStarted(state.selectedMatchId, streamUrl: streamUrl));
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start match'),
                style: FilledButton.styleFrom(
                  backgroundColor: DashboardColors.accentGreen,
                  foregroundColor: DashboardColors.textOnAccent,
                ),
              ),
            ],
            if (snap.scoringEnabled) ...[
              const SizedBox(height: AppSpacing.sm),
              FilledButton.tonalIcon(
                onPressed: () => bloc.add(ManageLeagueMatchEnded(state.selectedMatchId)),
                icon: const Icon(Icons.stop_circle_outlined),
                label: const Text('End match'),
              ),
            ],
            if (selectedFixture != null && selectedFixture.phase == LeagueFixturePhase.scheduled) ...[
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () async {
                    final kickoff = await showManageLeagueKickoffDialog(
                      context,
                      initialKickoffAt: selectedFixture.kickoffAt ??
                          DateTime.now().add(const Duration(days: 1)),
                    );
                    if (!context.mounted || kickoff == null) return;
                    bloc.add(
                      ManageLeagueScheduleUpdated(
                        matchId: selectedFixture.matchId,
                        kickoffAt: kickoff,
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_calendar_outlined),
                  label: const Text('Change kickoff time'),
                  style: FilledButton.styleFrom(
                    backgroundColor: DashboardColors.bgSurface,
                    foregroundColor: DashboardColors.textPrimary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, color: DashboardColors.textSecondary),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    snap.homeTeamName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'TIME',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
                    ),
                    Text(
                      snap.matchClock,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                Expanded(
                  child: Text(
                    snap.awayTeamName,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.shield_outlined, color: DashboardColors.textSecondary),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ManageLeagueTeamScoreCard(
                  teamShort: snap.homeTeamShort,
                  score: snap.homeScore,
                  scoringEnabled: snap.scoringEnabled,
                  photoUrl: snap.homePhotoUrl,
                  onMinus: () => bloc.add(const ManageLeagueHomeScoreDelta(-1)),
                  onPlus: () => bloc.add(const ManageLeagueHomeScoreDelta(1)),
                ),
                const SizedBox(width: AppSpacing.md),
                ManageLeagueTeamScoreCard(
                  teamShort: snap.awayTeamShort,
                  score: snap.awayScore,
                  scoringEnabled: snap.scoringEnabled,
                  photoUrl: snap.awayPhotoUrl,
                  onMinus: () => bloc.add(const ManageLeagueAwayScoreDelta(-1)),
                  onPlus: () => bloc.add(const ManageLeagueAwayScoreDelta(1)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: 'live',
                    decoration: InputDecoration(
                      labelText: 'Match Status',
                      filled: true,
                      fillColor: DashboardColors.bgCard,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'live', child: Text('Live - Second Half')),
                      DropdownMenuItem(value: 'ht', child: Text('Half-time')),
                    ],
                    onChanged: snap.scoringEnabled ? (_) {} : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Row(
                  children: [
                    Text(
                      'Knockout Stage Only',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: DashboardColors.textSecondary),
                    ),
                    Switch(value: false, onChanged: snap.scoringEnabled ? (_) {} : null),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

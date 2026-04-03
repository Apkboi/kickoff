import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';
import '../controllers/manage_league_bloc.dart';
import '../controllers/manage_league_event.dart';
import '../controllers/manage_league_state.dart';
import 'manage_league_end_league_dialog.dart';
import 'manage_league_schedule_dialog.dart';
import 'manage_league_mobile_events_section.dart';
import 'manage_league_mobile_fixtures_strip.dart';
import 'manage_league_stream_links_dialog.dart';
import 'manage_league_team_score_card.dart';

class ManageLeagueMobileBody extends StatelessWidget {
  const ManageLeagueMobileBody({
    required this.competitionId,
    super.key,
  });

  final String competitionId;

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
        final canEdit = snap.scoringEnabled;
        final selectedFixture = selected;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snap.leagueName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: DashboardColors.accentGreen,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ManageLeagueMobileFixturesStrip(competitionId: competitionId),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: FilledButton.tonalIcon(
                    onPressed: () async {
                      final name = await showManageLeagueEndLeagueDialog(context);
                      if (!context.mounted || name == null) return;
                      bloc.add(ManageLeagueCompetitionEnded(name));
                    },
                    icon: const Icon(Icons.emoji_events_outlined),
                    label: const Text('End tournament & declare winner'),
                  ),
                ),
              ),
              if (showStart)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () async {
                        final links = await showManageLeagueStreamLinksDialog(context);
                        if (!context.mounted || links == null) return;
                        bloc.add(ManageLeagueMatchStarted(state.selectedMatchId, streamLinks: links));
                      },
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('Start match'),
                      style: FilledButton.styleFrom(
                        backgroundColor: DashboardColors.accentGreen,
                        foregroundColor: DashboardColors.textOnAccent,
                      ),
                    ),
                  ),
                ),
              if (canEdit)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () => bloc.add(ManageLeagueMatchEnded(state.selectedMatchId)),
                      icon: const Icon(Icons.stop_circle_outlined),
                      label: const Text('End match'),
                    ),
                  ),
                ),
              if (selectedFixture != null && selectedFixture.phase == LeagueFixturePhase.scheduled)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: SizedBox(
                    height: 52,
                    width: double.infinity,
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
                      label: const Text('Change kickoff'),
                      style: FilledButton.styleFrom(
                        backgroundColor: DashboardColors.bgSurface,
                        foregroundColor: DashboardColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              if (snap.isLive)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Live match',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: DashboardColors.textSecondary),
                  ),
                ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                snap.matchTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: DashboardColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ManageLeagueTeamScoreCard(
                    teamShort: snap.homeTeamShort,
                    score: snap.homeScore,
                    scoringEnabled: canEdit,
                    photoUrl: snap.homePhotoUrl,
                    onMinus: () => bloc.add(const ManageLeagueHomeScoreDelta(-1)),
                    onPlus: () => bloc.add(const ManageLeagueHomeScoreDelta(1)),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ManageLeagueTeamScoreCard(
                    teamShort: snap.awayTeamShort,
                    score: snap.awayScore,
                    scoringEnabled: canEdit,
                    photoUrl: snap.awayPhotoUrl,
                    onMinus: () => bloc.add(const ManageLeagueAwayScoreDelta(-1)),
                    onPlus: () => bloc.add(const ManageLeagueAwayScoreDelta(1)),
                    leading: snap.awayPhotoUrl != null && snap.awayPhotoUrl!.isNotEmpty
                        ? null
                        : const Icon(Icons.sports_soccer, color: DashboardColors.textSecondary, size: 28),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              ManageLeagueMobileEventsSection(
                canEdit: canEdit,
                isEventsLoading: state.isEventsLoading,
                snapshot: snap,
                bloc: bloc,
              ),
            ],
          ),
        );
      },
    );
  }
}

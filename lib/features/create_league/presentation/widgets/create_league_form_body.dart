import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_format.dart';
import '../controllers/create_league_bloc.dart';
import '../controllers/create_league_event.dart';
import '../controllers/create_league_state.dart';
import 'create_league_automation_row.dart';
import 'create_league_basic_section.dart';
import 'create_league_creator_join_row.dart';
import 'create_league_format_cards.dart';
import 'create_league_metadata_section.dart';
import 'create_league_participants_section.dart';

class CreateLeagueFormBody extends StatelessWidget {
  const CreateLeagueFormBody({
    required this.state,
    required this.formatHorizontal,
    this.showAutomationToggle = true,
    super.key,
  });

  final CreateLeagueState state;
  final bool formatHorizontal;
  final bool showAutomationToggle;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateLeagueBloc>();
    return Material(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: DashboardColors.bgCard,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: DashboardColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateLeagueBasicSection(
                  leagueName: state.leagueName,
                  sport: state.sport,
                  onName: (v) => bloc.add(CreateLeagueNameChanged(v)),
                  onSport: (v) => bloc.add(CreateLeagueSportChanged(v)),
                ),
                const SizedBox(height: AppSpacing.xl),
                CreateLeagueMetadataSection(
                  endDate: state.endDate,
                  prizePool: state.prizePool,
                  logoUrl: state.logoUrl,
                  bannerUrl: state.bannerUrl,
                  logoPreviewBytes: state.logoPreviewBytes,
                  bannerPreviewBytes: state.bannerPreviewBytes,
                  logoUploading: state.logoUploading,
                  bannerUploading: state.bannerUploading,
                  logoUploadError: state.logoUploadError,
                  bannerUploadError: state.bannerUploadError,
                  onEndDate: (d) => bloc.add(CreateLeagueEndDateChanged(d)),
                  onPrizePool: (v) => bloc.add(CreateLeaguePrizePoolChanged(v)),
                  onLogoUrl: (v) => bloc.add(CreateLeagueLogoUrlChanged(v)),
                  onBannerUrl: (v) => bloc.add(CreateLeagueBannerUrlChanged(v)),
                ),
                const SizedBox(height: AppSpacing.xl),
                CreateLeagueFormatCards(
                  selected: state.format,
                  onSelect: (f) => bloc.add(CreateLeagueFormatSelected(f)),
                  horizontalScroll: formatHorizontal,
                ),
                const SizedBox(height: AppSpacing.lg),
                CreateLeagueAutomationRow(
                  showToggle: showAutomationToggle,
                  value: state.automateFixtures,
                  onChanged: showAutomationToggle
                      ? (v) => bloc.add(CreateLeagueAutomateToggled(v))
                      : null,
                ),
                if (state.format == LeagueFormat.solo) ...[
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<int>(
                    initialValue: state.soloMatchCount,
                    decoration: const InputDecoration(
                      labelText: '1v1 number of matches',
                      filled: true,
                    ),
                    items: List.generate(
                      20,
                      (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1} matches')),
                    ),
                    onChanged: (v) {
                      if (v != null) bloc.add(CreateLeagueSoloMatchCountChanged(v));
                    },
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                CreateLeagueCreatorJoinRow(
                  value: state.creatorJoinsAsParticipant,
                  onChanged: (v) => bloc.add(CreateLeagueCreatorJoinToggled(v)),
                ),
                const SizedBox(height: AppSpacing.lg),
                CreateLeagueParticipantsSection(
                  query: state.participantQuery,
                  adminQuery: state.adminQuery,
                  participants: state.participants,
                  admins: state.admins,
                  searchResults: state.userSearchResults,
                  adminSearchResults: state.adminSearchResults,
                  searchLoading: state.userSearchLoading,
                  adminSearchLoading: state.adminSearchLoading,
                  onQuery: (q) => bloc.add(CreateLeagueParticipantQueryChanged(q)),
                  onAdminQuery: (q) => bloc.add(CreateLeagueAdminQueryChanged(q)),
                  onRemove: (id) => bloc.add(CreateLeagueParticipantRemoved(id)),
                  onAddUser: (u) => bloc.add(CreateLeagueParticipantAdded(u)),
                  onAddAdmin: (u) => bloc.add(CreateLeagueAdminAdded(u)),
                  onAdminRemove: (id) => bloc.add(CreateLeagueAdminRemoved(id)),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _BottomActions(
            publishDisabled: state.publishing,
            onPublish: () => bloc.add(const CreateLeaguePublishPressed()),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.publishDisabled,
    required this.onPublish,
  });

  final bool publishDisabled;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        FilledButton(
          onPressed: publishDisabled ? null : onPublish,
          style: FilledButton.styleFrom(
            backgroundColor: DashboardColors.accentGreen,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
          ),
          child: Text(publishDisabled ? 'Publishing…' : 'Publish'),
        ),
      ],
    );
  }
}

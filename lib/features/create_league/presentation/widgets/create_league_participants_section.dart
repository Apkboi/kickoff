import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_participant_draft.dart';
import '../../domain/entities/user_search_result_entity.dart';

class CreateLeagueParticipantsSection extends StatefulWidget {
  const CreateLeagueParticipantsSection({
    required this.query,
    required this.adminQuery,
    required this.participants,
    required this.admins,
    required this.searchResults,
    required this.adminSearchResults,
    required this.searchLoading,
    required this.adminSearchLoading,
    required this.onQuery,
    required this.onAdminQuery,
    required this.onRemove,
    required this.onAddUser,
    required this.onAdminRemove,
    required this.onAddAdmin,
    super.key,
  });

  final String query;
  final String adminQuery;
  final List<LeagueParticipantDraft> participants;
  final List<LeagueParticipantDraft> admins;
  final List<UserSearchResultEntity> searchResults;
  final List<UserSearchResultEntity> adminSearchResults;
  final bool searchLoading;
  final bool adminSearchLoading;
  final ValueChanged<String> onQuery;
  final ValueChanged<String> onAdminQuery;
  final ValueChanged<String> onRemove;
  final ValueChanged<UserSearchResultEntity> onAddUser;
  final ValueChanged<String> onAdminRemove;
  final ValueChanged<UserSearchResultEntity> onAddAdmin;

  @override
  State<CreateLeagueParticipantsSection> createState() =>
      _CreateLeagueParticipantsSectionState();
}

class _CreateLeagueParticipantsSectionState extends State<CreateLeagueParticipantsSection> {
  late final TextEditingController _queryController;
  late final TextEditingController _adminQueryController;

  @override
  void initState() {
    super.initState();
    _queryController = TextEditingController(text: widget.query);
    _queryController.addListener(() {
      widget.onQuery(_queryController.text);
    });
    _adminQueryController = TextEditingController(text: widget.adminQuery);
    _adminQueryController.addListener(() {
      widget.onAdminQuery(_adminQueryController.text);
    });
  }

  @override
  void didUpdateWidget(covariant CreateLeagueParticipantsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.query != oldWidget.query && widget.query != _queryController.text) {
      _queryController.text = widget.query;
    }
    if (widget.adminQuery != oldWidget.adminQuery &&
        widget.adminQuery != _adminQueryController.text) {
      _adminQueryController.text = widget.adminQuery;
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    _adminQueryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Players',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DashboardColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _queryController,
          style: const TextStyle(color: DashboardColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_add_alt_1, color: DashboardColors.textSecondary),
            hintText: 'Search players by name…',
            hintStyle: const TextStyle(color: DashboardColors.textSecondary),
            filled: true,
            fillColor: DashboardColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: const BorderSide(color: DashboardColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: const BorderSide(color: DashboardColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: const BorderSide(color: DashboardColors.accentGreen, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          ),
        ),
        if (widget.searchLoading) ...[
          const SizedBox(height: AppSpacing.sm),
          const LinearProgressIndicator(
            minHeight: 2,
            color: DashboardColors.accentGreen,
            backgroundColor: DashboardColors.bgCard,
          ),
        ],
        if (widget.searchResults.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          ...widget.searchResults.map(
            (u) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Material(
                color: DashboardColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.button),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  onTap: () => widget.onAddUser(u),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.person, color: DashboardColors.accentGreen),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u.displayName,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: DashboardColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              Text(
                                u.subtitle,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: DashboardColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.add_circle_outline, color: DashboardColors.accentGreen),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        ...widget.participants.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _ParticipantTile(
              participant: p,
              onRemove: () => widget.onRemove(p.id),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Add League Admins',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DashboardColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _adminQueryController,
          style: const TextStyle(color: DashboardColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.shield_outlined, color: DashboardColors.textSecondary),
            hintText: 'Search admins by name…',
            hintStyle: const TextStyle(color: DashboardColors.textSecondary),
            filled: true,
            fillColor: DashboardColors.bgSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: const BorderSide(color: DashboardColors.borderSubtle),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: const BorderSide(color: DashboardColors.borderSubtle),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              borderSide: const BorderSide(color: DashboardColors.accentGreen, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
          ),
        ),
        if (widget.adminSearchLoading) ...[
          const SizedBox(height: AppSpacing.sm),
          const LinearProgressIndicator(
            minHeight: 2,
            color: DashboardColors.accentGreen,
            backgroundColor: DashboardColors.bgCard,
          ),
        ],
        if (widget.adminSearchResults.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          ...widget.adminSearchResults.map(
            (u) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Material(
                color: DashboardColors.bgSurface,
                borderRadius: BorderRadius.circular(AppRadius.button),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                  onTap: () => widget.onAddAdmin(u),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: DashboardColors.accentGreen),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            u.displayName,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: DashboardColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const Icon(Icons.add_circle_outline, color: DashboardColors.accentGreen),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        ...widget.admins.map(
          (a) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _AdminTile(
              admin: a,
              onRemove: () => widget.onAdminRemove(a.id),
            ),
          ),
        ),
      ],
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  const _ParticipantTile({
    required this.participant,
    required this.onRemove,
  });

  final LeagueParticipantDraft participant;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: DashboardColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: DashboardColors.bgCard,
            child: Icon(
              participant.isTeam ? Icons.groups : Icons.person,
              color: DashboardColors.accentGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: DashboardColors.textPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                Text(
                  participant.subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: DashboardColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: DashboardColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile({required this.admin, required this.onRemove});

  final LeagueParticipantDraft admin;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: DashboardColors.bgSurface,
        borderRadius: BorderRadius.circular(AppRadius.button),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundColor: DashboardColors.bgCard,
            child: Icon(Icons.shield_outlined, color: DashboardColors.accentGreen),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              admin.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DashboardColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close, color: DashboardColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

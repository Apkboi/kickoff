import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_fixture_summary_entity.dart';

class ManageLeagueFixtureRow extends StatelessWidget {
  const ManageLeagueFixtureRow({
    required this.fixture,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final LeagueFixtureSummaryEntity fixture;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final live = fixture.phase == LeagueFixturePhase.live;
    final scheduled = fixture.phase == LeagueFixturePhase.scheduled;
    final homeScore = scheduled ? '-' : '${fixture.homeScore}';
    final awayScore = scheduled ? '-' : '${fixture.awayScore}';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: live ? DashboardColors.accentGreen.withValues(alpha: 0.08) : DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: isSelected
                  ? DashboardColors.accentGreen
                  : live
                      ? DashboardColors.accentGreen.withValues(alpha: 0.55)
                      : DashboardColors.borderSubtle,
              width: isSelected ? 2 : live ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fixture.headline,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: DashboardColors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: live
                          ? DashboardColors.accentGreen.withValues(alpha: 0.2)
                          : scheduled
                              ? DashboardColors.bgSurface
                              : DashboardColors.bgSurface,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      live
                          ? 'LIVE'
                          : scheduled
                              ? 'SCHED'
                              : 'FT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: live ? DashboardColors.accentNeon : DashboardColors.textSecondary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                fixture.statusLine,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Builder(
                builder: (context) {
                  final names = _namesFromHeadline(fixture.headline);
                  return Row(
                    children: [
                      Expanded(
                        child: _FixtureSideAvatar(
                          photoUrl: fixture.homeAvatarUrl,
                          shortName: names.$1,
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _FixtureSideAvatar(
                            photoUrl: fixture.awayAvatarUrl,
                            shortName: names.$2,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    homeScore,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const Text('—', style: TextStyle(color: DashboardColors.textSecondary)),
                  Text(
                    awayScore,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

(String, String) _namesFromHeadline(String headline) {
  final parts = headline.split(RegExp(r'\s+vs\s+', caseSensitive: false));
  if (parts.length >= 2) {
    return (parts[0].trim(), parts[1].trim());
  }
  return ('Home', 'Away');
}

class _FixtureSideAvatar extends StatelessWidget {
  const _FixtureSideAvatar({required this.photoUrl, required this.shortName});

  final String? photoUrl;
  final String shortName;

  @override
  Widget build(BuildContext context) {
    final label = shortName.trim().isEmpty
        ? '?'
        : shortName.trim().toUpperCase().length <= 4
            ? shortName.trim().toUpperCase()
            : shortName.trim().toUpperCase().substring(0, 4);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: photoUrl != null && photoUrl!.isNotEmpty ? NetworkImage(photoUrl!) : null,
          child: photoUrl == null || photoUrl!.isEmpty
              ? Text(
                  label.isNotEmpty ? label[0] : '?',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}


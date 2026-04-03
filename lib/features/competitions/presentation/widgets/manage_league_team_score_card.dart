import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';

class ManageLeagueTeamScoreCard extends StatelessWidget {
  const ManageLeagueTeamScoreCard({
    required this.teamShort,
    required this.score,
    required this.onMinus,
    required this.onPlus,
    required this.scoringEnabled,
    this.leading,
    this.photoUrl,
    super.key,
  });

  final String teamShort;
  final int score;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final bool scoringEnabled;
  final Widget? leading;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;
    return Expanded(
      child: Opacity(
        opacity: scoringEnabled ? 1 : 0.45,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: DashboardColors.borderSubtle),
          ),
          child: Column(
            children: [
            leading ??
                CircleAvatar(
                  radius: 18,
                  backgroundColor: DashboardColors.bgSurface,
                  foregroundImage: hasPhoto ? NetworkImage(photoUrl!) : null,
                  onForegroundImageError: hasPhoto ? (_, __) {} : null,
                  child: const Icon(Icons.shield_outlined, color: DashboardColors.textSecondary, size: 20),
                ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '$score',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: DashboardColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              teamShort,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: DashboardColors.textSecondary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (scoringEnabled)
              Row(
                children: [
                  Expanded(
                    child: _RoundIconButton(
                      icon: Icons.remove,
                      onPressed: onMinus,
                      filled: false,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _RoundIconButton(
                      icon: Icons.add,
                      onPressed: onPlus,
                      filled: true,
                    ),
                  ),
                ],
              )
            else
              Text(
                'Locked',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: DashboardColors.textSecondary),
              ),
          ],
        ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
    required this.filled,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? DashboardColors.accentGreen : DashboardColors.bgSurface,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.button),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Icon(
            icon,
            color: filled ? DashboardColors.textOnAccent : DashboardColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import 'auth_glass_card.dart';

class AuthShowcaseCardsColumn extends StatelessWidget {
  const AuthShowcaseCardsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _StatusCard(),
          const SizedBox(height: AppSpacing.md),
          const _MatchCard(),
          const SizedBox(height: AppSpacing.md),
          const _QuoteCard(),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return AuthGlassCard(
      child: Row(
        children: [
          const Icon(Icons.insights, color: AppColors.authPrimary, size: 28),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LIVE ENGINE STATUS',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.0,
                        color: AppColors.authSubtleForeground,
                      ),
                ),
                Text(
                  'ACTIVE 98.4%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.authPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard();

  @override
  Widget build(BuildContext context) {
    return AuthGlassCard(
      highlightBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LIVE DATA STREAM',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.0,
                  color: AppColors.authSubtleForeground,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'MATCHWEEK 24',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.authForeground,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.shield, color: AppColors.authPrimary, size: 22),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'FC ELITE  3 — 1  UNITED',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.authForeground,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                "'84 MIN",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.authPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard();

  @override
  Widget build(BuildContext context) {
    return AuthGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              5,
              (_) => const Icon(
                Icons.star,
                color: AppColors.authRatingStar,
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '"The data depth here is unparalleled. Every metric, every '
            'millisecond captured for the elite game."',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.authForeground,
                  fontStyle: FontStyle.italic,
                  height: 1.35,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.authInputBackground,
                child: Icon(Icons.person, color: AppColors.authSubtleForeground),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'LEAD PERFORMANCE ANALYST',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.authPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

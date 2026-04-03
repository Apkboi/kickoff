import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/league_format.dart';
import '../models/league_format_ui.dart';

class CreateLeagueFormatCards extends StatelessWidget {
  const CreateLeagueFormatCards({
    required this.selected,
    required this.onSelect,
    required this.horizontalScroll,
    super.key,
  });

  final LeagueFormat selected;
  final ValueChanged<LeagueFormat> onSelect;
  final bool horizontalScroll;

  @override
  Widget build(BuildContext context) {
    const formats = LeagueFormat.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Competition Format',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: DashboardColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (horizontalScroll)
          SizedBox(
            height: 132,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var i = 0; i < formats.length; i++)
                  Padding(
                    padding: EdgeInsets.only(right: i < formats.length - 1 ? AppSpacing.sm : 0),
                    child: SizedBox(
                      width: 220,
                      child: _FormatCard(
                        format: formats[i],
                        selected: selected == formats[i],
                        onTap: () => onSelect(formats[i]),
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth >= 720) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < formats.length; i++)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: i < formats.length - 1 ? AppSpacing.sm : 0),
                          child: _FormatCard(
                            format: formats[i],
                            selected: selected == formats[i],
                            onTap: () => onSelect(formats[i]),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return Column(
                children: [
                  for (final f in formats)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _FormatCard(
                        format: f,
                        selected: selected == f,
                        onTap: () => onSelect(f),
                      ),
                    ),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    required this.format,
    required this.selected,
    required this.onTap,
  });

  final LeagueFormat format;
  final bool selected;
  final VoidCallback onTap;

  IconData get _icon {
    return switch (format) {
      LeagueFormat.knockout => Icons.account_tree_outlined,
      LeagueFormat.solo => Icons.person_outline,
      LeagueFormat.standard => Icons.bar_chart_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 132,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: DashboardColors.bgSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(
              color: selected ? DashboardColors.accentGreen : DashboardColors.borderSubtle,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_icon, color: selected ? DashboardColors.accentGreen : DashboardColors.textSecondary),
              const Spacer(),
              Text(
                LeagueFormatUi.title(format),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: DashboardColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                LeagueFormatUi.subtitle(format),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: DashboardColors.textSecondary,
                      height: 1.3,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

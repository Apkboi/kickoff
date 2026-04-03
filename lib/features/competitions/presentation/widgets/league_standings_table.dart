import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/standing_row_entity.dart';

String _gdLabel(int gd) {
  if (gd > 0) return '+$gd';
  return '$gd';
}

class LeagueStandingsTable extends StatelessWidget {
  const LeagueStandingsTable({required this.rows, super.key});

  final List<StandingRowEntity> rows;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: DashboardColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        );
    const numW = 36.0;
    return Container(
      decoration: BoxDecoration(
        color: DashboardColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: DashboardColors.borderSubtle),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                        child: Row(
                          children: [
                            SizedBox(width: 36, child: Text('#', style: headerStyle)),
                            Expanded(flex: 3, child: Text('TEAM', style: headerStyle)),
                            SizedBox(width: numW, child: Text('MP', style: headerStyle, textAlign: TextAlign.end)),
                            SizedBox(width: numW, child: Text('GF', style: headerStyle, textAlign: TextAlign.end)),
                            SizedBox(width: numW, child: Text('GA', style: headerStyle, textAlign: TextAlign.end)),
                            SizedBox(width: numW, child: Text('GD', style: headerStyle, textAlign: TextAlign.end)),
                            SizedBox(width: numW, child: Text('PTS', style: headerStyle, textAlign: TextAlign.end)),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: DashboardColors.borderSubtle),
                      for (final row in rows) _StandingRow(row: row, numW: numW),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StandingRow extends StatelessWidget {
  const _StandingRow({required this.row, required this.numW});

  final StandingRowEntity row;
  final double numW;

  @override
  Widget build(BuildContext context) {
    final rankColor = row.highlightRank ? DashboardColors.accentGreen : DashboardColors.textPrimary;
    final numStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: DashboardColors.textPrimary,
          fontWeight: FontWeight.w600,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              row.rank.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: rankColor,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Icon(Icons.shield_outlined, size: 18, color: rankColor),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    row.teamName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: DashboardColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: numW, child: Text('${row.matchesPlayed}', textAlign: TextAlign.end, style: numStyle)),
          SizedBox(width: numW, child: Text('${row.goalsFor}', textAlign: TextAlign.end, style: numStyle)),
          SizedBox(width: numW, child: Text('${row.goalsAgainst}', textAlign: TextAlign.end, style: numStyle)),
          SizedBox(
            width: numW,
            child: Text(
              _gdLabel(row.goalDifference),
              textAlign: TextAlign.end,
              style: numStyle,
            ),
          ),
          SizedBox(
            width: numW,
            child: Text(
              '${row.points}',
              textAlign: TextAlign.end,
              style: (numStyle ?? const TextStyle()).copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

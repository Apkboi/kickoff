import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/dashboard_colors.dart';
import '../../domain/entities/explore_feed_entity.dart';
import '../../domain/entities/explore_fee_range.dart';
import '../../domain/entities/explore_filters.dart';
import '../../domain/entities/explore_sort.dart';
import '../../domain/entities/explore_sport.dart';
import '../../domain/utils/apply_explore_filters.dart';
import 'explore_filter_sheet_widgets.dart';
import 'explore_filters_fee_block.dart';
import 'explore_filters_sheet_app_bar.dart';
import 'explore_filters_status_switches.dart';

class ExploreFiltersSheet extends StatefulWidget {
  const ExploreFiltersSheet({
    required this.feed,
    required this.searchQuery,
    required this.sort,
    required this.initial,
    required this.onApply,
    required this.onReset,
    super.key,
  });

  final ExploreFeedEntity feed;
  final String searchQuery;
  final ExploreSort sort;
  final ExploreFilters initial;
  final ValueChanged<ExploreFilters> onApply;
  final VoidCallback onReset;

  @override
  State<ExploreFiltersSheet> createState() => _ExploreFiltersSheetState();
}

class _ExploreFiltersSheetState extends State<ExploreFiltersSheet> {
  late ExploreFilters _draft;
  late RangeValues _feeRange;
  late final TextEditingController _locationController;

  ExploreFilters get _effectiveDraft => _draft.copyWith(
        entryFeeRange: ExploreFeeRange(min: _feeRange.start, max: _feeRange.end),
      );

  @override
  void initState() {
    super.initState();
    _draft = widget.initial;
    _feeRange = RangeValues(_draft.entryFeeRange.min, _draft.entryFeeRange.max);
    _locationController = TextEditingController(text: widget.initial.locationQuery);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  int get _resultCount {
    return applyExploreFilters(
      source: widget.feed.gridLeagues,
      filters: _effectiveDraft,
      searchQuery: widget.searchQuery,
      sort: widget.sort,
    ).length;
  }

  void _toggleSport(ExploreSport s) {
    setState(() {
      final next = Set<ExploreSport>.from(_draft.sports);
      if (next.contains(s)) {
        next.remove(s);
      } else {
        next.add(s);
      }
      _draft = _draft.copyWith(sports: next);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      decoration: const BoxDecoration(
        color: DashboardColors.bgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            ExploreFiltersSheetAppBar(
              onClose: () => Navigator.of(context).pop(),
              onReset: () {
                setState(() {
                  _draft = ExploreFilters.initial;
                  _feeRange = RangeValues(_draft.entryFeeRange.min, _draft.entryFeeRange.max);
                  _locationController.clear();
                });
                widget.onReset();
              },
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  const ExploreFilterSectionLabel(text: 'SPORT CATEGORY'),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      ExploreFilterSportChip(
                        label: 'Soccer',
                        selected: _draft.sports.contains(ExploreSport.soccer),
                        onTap: () => _toggleSport(ExploreSport.soccer),
                      ),
                      ExploreFilterSportChip(
                        label: 'Basketball',
                        selected: _draft.sports.contains(ExploreSport.basketball),
                        onTap: () => _toggleSport(ExploreSport.basketball),
                      ),
                      ExploreFilterSportChip(
                        label: 'Tennis',
                        selected: _draft.sports.contains(ExploreSport.tennis),
                        onTap: () => _toggleSport(ExploreSport.tennis),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const ExploreFilterSectionLabel(text: 'MATCH FORMAT'),
                  const SizedBox(height: AppSpacing.sm),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 2.8,
                    children: [
                      ExploreFilterFormatButton(
                        label: 'Standard League',
                        selected: _draft.standardLeague,
                        onTap: () => setState(
                          () => _draft = _draft.copyWith(standardLeague: !_draft.standardLeague),
                        ),
                      ),
                      ExploreFilterFormatButton(
                        label: 'Tournament',
                        selected: _draft.tournament,
                        onTap: () => setState(() => _draft = _draft.copyWith(tournament: !_draft.tournament)),
                      ),
                      ExploreFilterFormatButton(
                        label: 'Knockout',
                        selected: _draft.knockout,
                        onTap: () => setState(() => _draft = _draft.copyWith(knockout: !_draft.knockout)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ExploreFiltersStatusSwitches(
                    draft: _draft,
                    onChanged: (f) => setState(() => _draft = f),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ExploreFiltersFeeLocationBlock(
                    feeRange: _feeRange,
                    onFeeChanged: (v) => setState(() => _feeRange = v),
                    locationController: _locationController,
                    onLocationChanged: (v) => setState(() => _draft = _draft.copyWith(locationQuery: v)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: FilledButton(
                onPressed: () => widget.onApply(_effectiveDraft),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: DashboardColors.accentGreen,
                  foregroundColor: DashboardColors.textOnAccent,
                ),
                child: Text(
                  'SHOW $_resultCount RESULTS',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

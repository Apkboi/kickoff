import 'package:equatable/equatable.dart';

import 'explore_fee_range.dart';
import 'explore_sport.dart';

class ExploreFilters extends Equatable {
  const ExploreFilters({
    this.sports = const {},
    this.standardLeague = false,
    this.tournament = false,
    this.knockout = false,
    this.registrationOpen = false,
    this.liveNow = false,
    this.startingSoon = false,
    this.entryFeeRange = ExploreFeeRange.initial,
    this.locationQuery = '',
  });

  final Set<ExploreSport> sports;
  final bool standardLeague;
  final bool tournament;
  final bool knockout;
  final bool registrationOpen;
  final bool liveNow;
  final bool startingSoon;
  final ExploreFeeRange entryFeeRange;
  final String locationQuery;

  static const ExploreFilters initial = ExploreFilters();

  ExploreFilters copyWith({
    Set<ExploreSport>? sports,
    bool? standardLeague,
    bool? tournament,
    bool? knockout,
    bool? registrationOpen,
    bool? liveNow,
    bool? startingSoon,
    ExploreFeeRange? entryFeeRange,
    String? locationQuery,
  }) {
    return ExploreFilters(
      sports: sports ?? this.sports,
      standardLeague: standardLeague ?? this.standardLeague,
      tournament: tournament ?? this.tournament,
      knockout: knockout ?? this.knockout,
      registrationOpen: registrationOpen ?? this.registrationOpen,
      liveNow: liveNow ?? this.liveNow,
      startingSoon: startingSoon ?? this.startingSoon,
      entryFeeRange: entryFeeRange ?? this.entryFeeRange,
      locationQuery: locationQuery ?? this.locationQuery,
    );
  }

  @override
  List<Object?> get props => [
        sports,
        standardLeague,
        tournament,
        knockout,
        registrationOpen,
        liveNow,
        startingSoon,
        entryFeeRange,
        locationQuery,
      ];
}

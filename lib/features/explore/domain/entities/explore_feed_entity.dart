import 'package:equatable/equatable.dart';

import 'explore_league_card_entity.dart';
import 'explore_suggested_row_entity.dart';

class ExploreFeedEntity extends Equatable {
  const ExploreFeedEntity({
    required this.gridLeagues,
    required this.trending,
    required this.suggested,
  });

  final List<ExploreLeagueCardEntity> gridLeagues;
  final List<ExploreLeagueCardEntity> trending;
  final List<ExploreSuggestedRowEntity> suggested;

  @override
  List<Object?> get props => [gridLeagues, trending, suggested];
}

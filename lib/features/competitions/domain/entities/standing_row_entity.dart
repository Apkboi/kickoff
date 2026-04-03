import 'package:equatable/equatable.dart';

class StandingRowEntity extends Equatable {
  const StandingRowEntity({
    required this.rank,
    required this.teamName,
    required this.matchesPlayed,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
    this.highlightRank = false,
  });

  final int rank;
  final String teamName;
  final int matchesPlayed;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final bool highlightRank;

  int get goalDifference => goalsFor - goalsAgainst;

  @override
  List<Object?> get props => [
        rank,
        teamName,
        matchesPlayed,
        goalsFor,
        goalsAgainst,
        points,
        highlightRank,
      ];
}

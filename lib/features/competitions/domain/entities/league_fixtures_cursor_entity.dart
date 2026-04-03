import 'package:equatable/equatable.dart';

class LeagueFixturesCursorEntity extends Equatable {
  const LeagueFixturesCursorEntity({
    required this.lastMatchIndex,
    required this.lastMatchId,
  });

  final int lastMatchIndex;
  final String lastMatchId;

  @override
  List<Object?> get props => [lastMatchIndex, lastMatchId];
}


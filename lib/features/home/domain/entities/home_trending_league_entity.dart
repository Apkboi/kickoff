import 'package:equatable/equatable.dart';

class HomeTrendingLeagueEntity extends Equatable {
  const HomeTrendingLeagueEntity({
    required this.id,
    required this.name,
    required this.sportLabel,
    required this.participantCount,
    required this.maxParticipants,
  });

  final String id;
  final String name;
  final String sportLabel;
  final int participantCount;
  final int maxParticipants;

  String get subtitle => '$participantCount / $maxParticipants players';

  @override
  List<Object?> get props => [id, name, sportLabel, participantCount, maxParticipants];
}

import 'package:equatable/equatable.dart';

/// Suggested list row (mobile).
class ExploreSuggestedRowEntity extends Equatable {
  const ExploreSuggestedRowEntity({
    required this.leagueId,
    required this.categoryLine,
    required this.title,
    required this.statusLine,
    required this.isFull,
    this.thumbnailIndex = 0,
  });

  final String leagueId;
  final String categoryLine;
  final String title;
  final String statusLine;
  final bool isFull;
  final int thumbnailIndex;

  @override
  List<Object?> get props => [
        leagueId,
        categoryLine,
        title,
        statusLine,
        isFull,
        thumbnailIndex,
      ];
}

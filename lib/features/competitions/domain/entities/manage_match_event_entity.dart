import 'package:equatable/equatable.dart';

enum ManageMatchEventKind { goal, yellowCard, redCard, substitution }

class ManageMatchEventEntity extends Equatable {
  const ManageMatchEventEntity({
    required this.id,
    required this.minuteLabel,
    required this.title,
    required this.subtitle,
    required this.kind,
  });

  final String id;
  final String minuteLabel;
  final String title;
  final String subtitle;
  final ManageMatchEventKind kind;

  @override
  List<Object?> get props => [id, minuteLabel, title, subtitle, kind];
}

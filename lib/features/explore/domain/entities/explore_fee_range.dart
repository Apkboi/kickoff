import 'package:equatable/equatable.dart';

class ExploreFeeRange extends Equatable {
  const ExploreFeeRange({required this.min, required this.max});

  final double min;
  final double max;

  static const ExploreFeeRange initial = ExploreFeeRange(min: 0, max: 1000);

  @override
  List<Object?> get props => [min, max];
}

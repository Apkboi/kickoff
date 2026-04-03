import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/explore_feed_entity.dart';
import '../repositories/explore_repository.dart';

class GetExploreFeedParams extends Equatable {
  const GetExploreFeedParams();

  @override
  List<Object?> get props => [];
}

class GetExploreFeedUseCase {
  const GetExploreFeedUseCase(this._repository);

  final ExploreRepository _repository;

  Future<Either<Failure, ExploreFeedEntity>> call(GetExploreFeedParams params) {
    return _repository.getFeed();
  }
}

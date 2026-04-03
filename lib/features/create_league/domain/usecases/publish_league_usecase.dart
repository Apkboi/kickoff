import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/league_publish_repository.dart';

class PublishLeagueUseCase {
  const PublishLeagueUseCase(this._repository);

  final LeaguePublishRepository _repository;

  Future<Either<Failure, String>> call(PublishLeagueParams params) {
    return _repository.publish(params);
  }
}

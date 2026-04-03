import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/explore_feed_entity.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  const ExploreRepositoryImpl(this._remote);

  final ExploreRemoteDataSource _remote;

  @override
  Future<Either<Failure, ExploreFeedEntity>> getFeed() async {
    try {
      final feed = await _remote.getFeed();
      return Right(feed);
    } catch (_) {
      return const Left(UnknownFailure('Unable to load explore'));
    }
  }
}

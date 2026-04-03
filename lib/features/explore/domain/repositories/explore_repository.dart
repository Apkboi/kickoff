import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/explore_feed_entity.dart';

abstract class ExploreRepository {
  Future<Either<Failure, ExploreFeedEntity>> getFeed();
}

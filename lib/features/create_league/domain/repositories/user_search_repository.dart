import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_search_result_entity.dart';

abstract class UserSearchRepository {
  Future<Either<Failure, List<UserSearchResultEntity>>> searchUsers({
    required String query,
    String? excludeUserId,
  });
}

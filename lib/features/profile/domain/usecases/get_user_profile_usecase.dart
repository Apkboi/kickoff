import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetUserProfileParams extends Equatable {
  const GetUserProfileParams({required this.uid});

  final String uid;

  @override
  List<Object?> get props => [uid];
}

class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, UserProfileEntity>> call(GetUserProfileParams params) {
    return _repository.getUserProfile(params.uid);
  }
}

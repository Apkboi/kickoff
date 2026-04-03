import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../entities/auth_user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUserParams extends Equatable {
  const GetCurrentUserParams();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthUserEntity>> call(GetCurrentUserParams params) {
    return _repository.getCurrentUser();
  }
}

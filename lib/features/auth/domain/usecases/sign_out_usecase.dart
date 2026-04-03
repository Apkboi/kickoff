import 'package:dartz/dartz.dart';

import '../../../../core/domain/no_params.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.signOut();
  }
}

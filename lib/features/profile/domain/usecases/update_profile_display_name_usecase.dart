import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileDisplayNameParams {
  const UpdateProfileDisplayNameParams({required this.displayName});

  final String displayName;
}

class UpdateProfileDisplayNameUseCase {
  UpdateProfileDisplayNameUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, Unit>> call(UpdateProfileDisplayNameParams params) {
    return _repository.updateDisplayName(params.displayName);
  }
}

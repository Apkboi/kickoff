import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SendPasswordResetParams extends Equatable {
  const SendPasswordResetParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class SendPasswordResetUseCase {
  const SendPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, void>> call(SendPasswordResetParams params) {
    return _repository.sendPasswordResetEmail(params.email);
  }
}

// lib/domain/usecases/user_usecases.dart

import 'package:if_found_lost/domain/entities/user_entity.dart';
import 'package:if_found_lost/domain/repositories/user_repository.dart';

class GetUserProfileUseCase {
  final UserRepository repository;

  GetUserProfileUseCase(this.repository);

  Stream<UserEntity?> execute(String userId) {
    return repository.getUserProfile(userId);
  }
}

class CreateUserProfileUseCase {
  final UserRepository repository;

  CreateUserProfileUseCase(this.repository);

  Future<void> execute(UserEntity user) {
    return repository.createUserProfile(user);
  }
}

class UpdateUserProfileUseCase {
  final UserRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> execute({
    required String userId,
    String? name,
    String? phone,
    String? address,
  }) {
    return repository.updateUserProfile(
      userId: userId,
      name: name,
      phone: phone,
      address: address,
    );
  }
}

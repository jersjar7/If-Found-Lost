// lib/domain/repositories/user_repository.dart

import 'package:if_found_lost/domain/entities/user_entity.dart';

abstract class UserRepository {
  // Get current user profile
  Stream<UserEntity?> getUserProfile(String userId);

  // Create a new user profile
  Future<void> createUserProfile(UserEntity user);

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
  });
}

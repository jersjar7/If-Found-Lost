// lib/domain/repositories/auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:if_found_lost/domain/entities/user_entity.dart';

abstract class AuthRepository {
  // Get the current authenticated user
  Stream<User?> get authStateChanges;

  // Gets the current user entity
  Future<UserEntity?> getCurrentUser();

  // Sign in with email and password
  Future<UserEntity> signInWithEmailAndPassword(String email, String password);

  // Create a new user with email and password
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  // Sign out the current user
  Future<void> signOut();
}

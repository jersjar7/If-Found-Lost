// lib/domain/usecases/auth_usecases.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:if_found_lost/domain/entities/user_entity.dart';
import 'package:if_found_lost/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) {
    return repository.signInWithEmailAndPassword(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) {
    return repository.createUserWithEmailAndPassword(email, password);
  }
}

class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<void> execute() {
    return repository.signOut();
  }
}

class GetAuthStateUseCase {
  final AuthRepository repository;

  GetAuthStateUseCase(this.repository);

  Stream<User?> execute() {
    return repository.authStateChanges;
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> execute() {
    return repository.getCurrentUser();
  }
}

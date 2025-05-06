// lib/data/repositories/auth_repository_impl.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:if_found_lost/data/datasources/remote/auth_remote_datasource.dart';
import 'package:if_found_lost/data/models/user_model.dart';
import 'package:if_found_lost/domain/entities/user_entity.dart';
import 'package:if_found_lost/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<User?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = await remoteDataSource.getCurrentUser();
    if (user == null) return null;

    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await remoteDataSource.signInWithEmailAndPassword(
      email,
      password,
    );
    final user = result.user;
    if (user == null) {
      throw Exception('Failed to sign in: user is null');
    }

    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserEntity> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final result = await remoteDataSource.createUserWithEmailAndPassword(
      email,
      password,
    );
    final user = result.user;
    if (user == null) {
      throw Exception('Failed to create user: user is null');
    }

    return UserModel(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> signOut() {
    return remoteDataSource.signOut();
  }
}

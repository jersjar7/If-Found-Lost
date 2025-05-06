// lib/data/repositories/user_repository_impl.dart

import 'package:if_found_lost/data/datasources/remote/user_remote_datasource.dart';
import 'package:if_found_lost/data/models/user_model.dart';
import 'package:if_found_lost/domain/entities/user_entity.dart';
import 'package:if_found_lost/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl({required this.remoteDatasource});

  @override
  Stream<UserEntity?> getUserProfile(String userId) {
    return remoteDatasource.getUserProfile(userId);
  }

  @override
  Future<void> createUserProfile(UserEntity user) async {
    await remoteDatasource.createUserProfile(UserModel.fromEntity(user));
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
  }) async {
    await remoteDatasource.updateUserProfile(
      userId: userId,
      name: name,
      phone: phone,
      address: address,
    );
  }
}

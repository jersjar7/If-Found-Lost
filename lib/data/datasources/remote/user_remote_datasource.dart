// lib/data/datasources/remote/user_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:if_found_lost/data/models/user_model.dart';

abstract class UserRemoteDatasource {
  Stream<UserModel?> getUserProfile(String userId);
  Future<void> createUserProfile(UserModel user);
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
  });
}

class FirebaseUserDatasource implements UserRemoteDatasource {
  final FirebaseFirestore _firestore;

  FirebaseUserDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<UserModel?> getUserProfile(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  @override
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toMap());
  }

  @override
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? phone,
    String? address,
  }) async {
    final updates = <String, dynamic>{};
    if (name != null) updates['name'] = name;
    if (phone != null) updates['phone'] = phone;
    if (address != null) updates['address'] = address;

    await _firestore.collection('users').doc(userId).update(updates);
  }
}

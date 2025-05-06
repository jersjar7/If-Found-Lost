// lib/domain/entities/user_entity.dart

// User entity represents the domain model of a user
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? address;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.address,
  });
}

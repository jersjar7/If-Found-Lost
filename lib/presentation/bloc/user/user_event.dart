// lib/presentation/bloc/user/user_event.dart

// Part of the user_bloc.dart file
part of 'user_bloc.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => []; // Changed to Object? to handle nullable types
}

class LoadUserProfileEvent extends UserEvent {
  final String userId;

  const LoadUserProfileEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class CreateUserProfileEvent extends UserEvent {
  final UserEntity user;

  const CreateUserProfileEvent({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateUserProfileEvent extends UserEvent {
  final String userId;
  final String? name;
  final String? phone;
  final String? address;

  const UpdateUserProfileEvent({
    required this.userId,
    this.name,
    this.phone,
    this.address,
  });

  @override
  List<Object> get props => [userId];
}

class UserProfileUpdatedEvent extends UserEvent {
  final UserEntity? userProfile;

  const UserProfileUpdatedEvent({this.userProfile});

  @override
  List<Object?> get props => [userProfile];
}

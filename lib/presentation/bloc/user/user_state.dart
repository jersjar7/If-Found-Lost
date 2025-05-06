// lib/presentation/bloc/user/user_state.dart

// Part of the user_bloc.dart file
part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => []; // Changed to Object? to handle nullable types
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserProfileLoaded extends UserState {
  final UserEntity userProfile;

  const UserProfileLoaded({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class UserProfileNotFound extends UserState {}

class UserProfileCreated extends UserState {}

class UserProfileUpdated extends UserState {}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

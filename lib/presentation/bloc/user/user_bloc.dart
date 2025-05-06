// lib/presentation/bloc/user/user_bloc.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:if_found_lost/domain/entities/user_entity.dart';
import 'package:if_found_lost/domain/usecases/user_usecases.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final CreateUserProfileUseCase createUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  StreamSubscription? _userProfileSubscription;

  UserBloc({
    required this.getUserProfileUseCase,
    required this.createUserProfileUseCase,
    required this.updateUserProfileUseCase,
  }) : super(UserInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<CreateUserProfileEvent>(_onCreateUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UserProfileUpdatedEvent>(_onUserProfileUpdated);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());

    await _userProfileSubscription?.cancel();
    _userProfileSubscription = getUserProfileUseCase
        .execute(event.userId)
        .listen(
          (userProfile) =>
              add(UserProfileUpdatedEvent(userProfile: userProfile)),
          onError: (error) => emit(UserError(message: error.toString())),
        );
  }

  Future<void> _onCreateUserProfile(
    CreateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await createUserProfileUseCase.execute(event.user);
      emit(UserProfileCreated());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await updateUserProfileUseCase.execute(
        userId: event.userId,
        name: event.name,
        phone: event.phone,
        address: event.address,
      );
      emit(UserProfileUpdated());
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  void _onUserProfileUpdated(
    UserProfileUpdatedEvent event,
    Emitter<UserState> emit,
  ) {
    final userProfile = event.userProfile;
    if (userProfile != null) {
      emit(UserProfileLoaded(userProfile: userProfile));
    } else {
      emit(UserProfileNotFound());
    }
  }

  @override
  Future<void> close() {
    _userProfileSubscription?.cancel();
    return super.close();
  }
}

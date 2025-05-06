// lib/core/errors/failures.dart

// Base failure class for domain layer
abstract class Failure {
  final String message;

  Failure({required this.message});
}

// Authentication failures
class AuthFailure extends Failure {
  AuthFailure({required super.message});
}

// User profile failures
class UserFailure extends Failure {
  UserFailure({required super.message});
}

// Network failures
class NetworkFailure extends Failure {
  NetworkFailure({required super.message});
}

// Server failures
class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

// General failures
class GeneralFailure extends Failure {
  GeneralFailure({required super.message});
}

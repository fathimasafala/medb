part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginResponse response;
  AuthSuccess(this.response);
}
class RegisterSuccess extends AuthState {
  final String message;
  RegisterSuccess(this.message);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
class LogoutSuccess extends AuthState {
  final bool message;
  LogoutSuccess(this.message);
}
class LogoutFailure extends AuthState {
  final String error;
  LogoutFailure(this.error);
}

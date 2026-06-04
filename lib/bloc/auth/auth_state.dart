part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  final bool isGoogle;

  const AuthLoading({this.isGoogle = false});

  @override
  List<Object?> get props => [isGoogle];
}

class Authenticated extends AuthState {
  final String role;

  const Authenticated(this.role);

  @override
  List<Object?> get props => [role];
}

class SignUpSuccess extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  const AuthFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

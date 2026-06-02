import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tier_3_fst_pro/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
  }

  String _getCleanErrorMessage(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'user-not-found':
          return 'This user is not available.';
        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'The password is too weak.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'invalid-email':
          return 'Invalid email format.';
        default:
          return e.message ?? 'Authentication failed.';
      }
    }
    return e.toString();
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(Authenticated());
      } else {
        emit(const AuthFailure('Login failed: User is null'));
      }
    } catch (e) {
      emit(AuthFailure(_getCleanErrorMessage(e)));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUp(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        await _authRepository.signOut();
        emit(SignUpSuccess());
      } else {
        emit(const AuthFailure('Sign up failed: User is null'));
      }
    } catch (e) {
      emit(AuthFailure(_getCleanErrorMessage(e)));
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.sendPasswordReset(email: event.email);
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(_getCleanErrorMessage(e)));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(_getCleanErrorMessage(e)));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signInWithGoogle();
      if (user != null) {
        emit(Authenticated());
      } else {
        // User cancelled sign in
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(_getCleanErrorMessage(e)));
    }
  }
}

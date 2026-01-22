part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginLoaded extends LoginState {
  final String message;
  final bool loginLoading;
  final bool googleLoading;
  final bool obscureText;

  const LoginLoaded({
    this.message = '',
    this.loginLoading = false,
    this.googleLoading = false,
    this.obscureText = true,
  });

  LoginLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loginLoading,
    ValueGetter<bool>? googleLoading,
    ValueGetter<bool>? obscureText,
  }) {
    return LoginLoaded(
      message: message != null ? message() : this.message,
      loginLoading: loginLoading != null ? loginLoading() : this.loginLoading,
      googleLoading: googleLoading != null ? googleLoading() : this.googleLoading,
      obscureText: obscureText != null ? obscureText() : this.obscureText,
    );
  }

  @override
  List<Object?> get props => [message, loginLoading, googleLoading, obscureText];
}

class LoginEmpty extends LoginState {}

class LoginFailure extends LoginState {}

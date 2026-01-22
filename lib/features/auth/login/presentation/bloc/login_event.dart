part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginLoadRequested extends LoginEvent {}

class ToggleVisiblePassword extends LoginEvent {
  final bool value;

  const ToggleVisiblePassword(this.value);

  @override
  List<Object?> get props => [value];
}

class SetMessage extends LoginEvent {
  final String value;

  const SetMessage(this.value);

  @override
  List<Object?> get props => [value];
}

class CloseMessage extends LoginEvent {}

class LoginRequest extends LoginEvent {
  final String email;
  final String password;

  const LoginRequest(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class GoogleSignIn extends LoginEvent {}
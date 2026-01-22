part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterLoadRequested extends RegisterEvent {}

class ToggleVisiblePassword extends RegisterEvent {
  final bool value;

  const ToggleVisiblePassword(this.value);

  @override
  List<Object?> get props => [value];
}

class PasswordChanged extends RegisterEvent {
  final String value;
  const PasswordChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class VerifyCodeRequested extends RegisterEvent {
  final RegisterRequestModel args;

  const VerifyCodeRequested(this.args);

  @override
  List<Object?> get props => [args];
}

class SendCodeRequested extends RegisterEvent {
  final RegisterRequestModel args;

  const SendCodeRequested(this.args);

  @override
  List<Object?> get props => [args];
}

class StartTimer extends RegisterEvent {}

class GoogleSignIn extends RegisterEvent {}

class ValidateReferrerPhone extends RegisterEvent {
  final String phone;

  const ValidateReferrerPhone(this.phone);

  @override
  List<Object?> get props => [phone];
}

class EnableIndicator extends RegisterEvent {
  final bool value;

  const EnableIndicator(this.value);

  @override
  List<Object?> get props => [value];
}

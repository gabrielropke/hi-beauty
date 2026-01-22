part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordLoadRequested extends ForgotPasswordEvent {}

class ToggleVisiblePassword extends ForgotPasswordEvent {
  final bool value;

  const ToggleVisiblePassword(this.value);

  @override
  List<Object?> get props => [value];
}

class VerifyCodeRequested extends ForgotPasswordEvent {
  final ForgotPasswordModel args;

  const VerifyCodeRequested(this.args);

  @override
  List<Object?> get props => [args];
}

class SendCodeRequested extends ForgotPasswordEvent {
  final ForgotPasswordModel args;

  const SendCodeRequested(this.args);

  @override
  List<Object?> get props => [args];
}

class ResetPasswordRequest extends ForgotPasswordEvent {
  final ForgotPasswordModel args;

  const ResetPasswordRequest(this.args);

  @override
  List<Object?> get props => [args];
}

class CloseMessage extends ForgotPasswordEvent {}

class StartTimer extends ForgotPasswordEvent {}

class PasswordChanged extends ForgotPasswordEvent {
  final String value;
  const PasswordChanged(this.value);
  @override
  List<Object?> get props => [value];
}
part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordLoaded extends ForgotPasswordState {
  final Map<String, String> message;
  final bool loading;
  final bool obscureText;
  final TimerController? timerController;
  final bool timerActive;
  final int seconds;
  final String password;

  const ForgotPasswordLoaded({
    this.message = const {'': ''},
    this.loading = false,
    this.obscureText = true,
    this.timerController,
    this.timerActive = false,
    this.seconds = 120,
    this.password = '',
  });

  ForgotPasswordLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
    ValueGetter<bool>? obscureText,
    ValueGetter<TimerController?>? timerController,
    ValueGetter<bool>? timerActive,
    ValueGetter<int>? seconds,
    ValueGetter<String>? password,
  }) {
    return ForgotPasswordLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      obscureText: obscureText != null ? obscureText() : this.obscureText,
      timerController: timerController != null
          ? timerController()
          : this.timerController,
      timerActive: timerActive != null
          ? timerActive()
          : this.timerActive,
      seconds: seconds != null ? seconds() : this.seconds,
      password: password != null ? password() : this.password,
    );
  }

  @override
  List<Object?> get props => [message, loading, obscureText, timerController, timerActive, seconds, password];
}

class ForgotPasswordEmpty extends ForgotPasswordState {}

class ForgotPasswordFailure extends ForgotPasswordState {}

extension PasswordCheck on String {
  bool get hasMin6 => length >= 6;
  bool get hasUpper => contains(RegExp(r'[A-Z]'));
  bool get hasLower => contains(RegExp(r'[a-z]'));
  bool get hasSpecial =>
      contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\[\]\\;/+=]'));
  Set<PasswordRule> get metRules => {
    if (hasMin6) PasswordRule.min6,
    if (hasUpper) PasswordRule.upper,
    if (hasLower) PasswordRule.lower,
    if (hasSpecial) PasswordRule.special,
  };
}

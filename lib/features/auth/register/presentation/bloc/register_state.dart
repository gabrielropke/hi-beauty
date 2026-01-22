part of 'register_bloc.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterLoaded extends RegisterState {
  final String message;
  final String referrerMessage;
  final bool registerLoading;
  final bool googleLoading;
  final bool obscureText;
  final String password;
  final String? verifiedTokenLabel;
  final bool? verifiedToken;
  final TimerController? timerController;
  final bool timerActive;
  final int seconds;
  final ReferrerModel? referrerInfo;
  final bool indicatorEnabled;

  const RegisterLoaded({
    this.message = '',
    this.referrerMessage = '',
    this.registerLoading = false,
    this.googleLoading = false,
    this.obscureText = true,
    this.password = '',
    this.verifiedTokenLabel,
    this.verifiedToken,
    this.timerController,
    this.timerActive = false,
    this.seconds = 120,
    this.referrerInfo,
    this.indicatorEnabled = false,
  });

  RegisterLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<String>? referrerMessage,
    ValueGetter<bool>? registerLoading,
    ValueGetter<bool>? googleLoading,
    ValueGetter<bool>? obscureText,
    ValueGetter<String>? password,
    ValueGetter<String?>? verifiedTokenLabel,
    ValueGetter<bool?>? verifiedToken,
    ValueGetter<TimerController?>? timerController,
    ValueGetter<bool>? timerActive,
    ValueGetter<int>? seconds,
    ValueGetter<ReferrerModel?>? referrerInfo,
    ValueGetter<bool>? indicatorEnabled,
  }) {
    return RegisterLoaded(
      message: message != null ? message() : this.message,
      referrerMessage: referrerMessage != null ? referrerMessage() : this.referrerMessage,
      registerLoading: registerLoading != null ? registerLoading() : this.registerLoading,
      googleLoading: googleLoading != null ? googleLoading() : this.googleLoading,
      obscureText: obscureText != null ? obscureText() : this.obscureText,
      password: password != null ? password() : this.password,
      verifiedTokenLabel: verifiedTokenLabel != null
          ? verifiedTokenLabel()
          : this.verifiedTokenLabel,
      verifiedToken: verifiedToken != null
          ? verifiedToken()
          : this.verifiedToken,
      timerController: timerController != null
          ? timerController()
          : this.timerController,
      timerActive: timerActive != null ? timerActive() : this.timerActive,
      seconds: seconds != null ? seconds() : this.seconds,
      referrerInfo: referrerInfo != null ? referrerInfo() : this.referrerInfo,
      indicatorEnabled: indicatorEnabled != null
          ? indicatorEnabled()
          : this.indicatorEnabled,
    );
  }

  @override
  List<Object?> get props => [
    message,
    referrerMessage,
    registerLoading,
    googleLoading,
    obscureText,
    password,
    verifiedTokenLabel,
    verifiedToken,
    timerController,
    timerActive,
    seconds,
    referrerInfo,
    indicatorEnabled,
  ];
}

class RegisterEmpty extends RegisterState {}

class RegisterFailure extends RegisterState {}

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

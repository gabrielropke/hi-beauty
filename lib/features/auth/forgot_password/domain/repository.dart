import 'package:hibeauty/features/auth/forgot_password/data/model.dart';

abstract class ForgotPasswordRepository {
  Future<void> sendCode(String email);
  Future<void> verifyCode(String email, String code);
  Future<void> resetPassword(ForgotPasswordModel request);
}

class SendCode {
  final ForgotPasswordRepository repository;
  SendCode(this.repository);

  Future<void> call(String email) {
    return repository.sendCode(email);
  }
}

class VerifyCode {
  final ForgotPasswordRepository repository;
  VerifyCode(this.repository);

  Future<void> call(String email, String code) {
    return repository.verifyCode(email, code);
  }
}

class ForgotPassword {
  final ForgotPasswordRepository repository;
  ForgotPassword(this.repository);

  Future<void> call(ForgotPasswordModel request) {
    return repository.resetPassword(request);
  }
}

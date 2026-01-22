import 'package:hibeauty/features/auth/register/data/model.dart';

abstract class RegisterRepository {
  Future<void> sendCode(String email);
  Future<void> verifyCode(String email, String code);
  Future<void> register(RegisterRequestModel request);
  Future<ReferrerModel> validateReferrerPhone(String phone);
}

class SendCode {
  final RegisterRepository repository;
  SendCode(this.repository);

  Future<void> call(String email) {
    return repository.sendCode(email);
  }
}

class VerifyCode {
  final RegisterRepository repository;
  VerifyCode(this.repository);

  Future<void> call(String email, String code) {
    return repository.verifyCode(email, code);
  }
}

class Register {
  final RegisterRepository repository;
  Register(this.repository);

  Future<void> call(RegisterRequestModel request) {
    return repository.register(request);
  }
}

class ValidateReferrerPhone {
  final RegisterRepository repository;
  ValidateReferrerPhone(this.repository);

  Future<ReferrerModel> call(String phone) {
    return repository.validateReferrerPhone(phone);
  }
}


import '../data/model.dart';

abstract class LoginRepository {
  Future<void> login(LoginRequest request);
}

class Login {
  final LoginRepository repository;
  Login(this.repository);

  Future<void> call(LoginRequest request) {
    return repository.login(request);
  }
}

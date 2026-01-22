import 'package:hibeauty/core/data/user.dart';

abstract class GetUserRepository {
  Future<User> fetchInitial();
}

class GetUser {
  final GetUserRepository repository;
  GetUser(this.repository);

  Future<User> call() {
    return repository.fetchInitial();
  }
}

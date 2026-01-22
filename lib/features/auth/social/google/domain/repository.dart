import 'package:hibeauty/core/data/user.dart';

abstract class GoogleAuthRepository {
  Future<User> exchangeIdToken(String idToken);
}

class GoogleExchangeIdToken {
  final GoogleAuthRepository repository;
  GoogleExchangeIdToken(this.repository);

  Future<User> call(String idToken) => repository.exchangeIdToken(idToken);
}

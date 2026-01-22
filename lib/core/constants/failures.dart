abstract class Failure {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

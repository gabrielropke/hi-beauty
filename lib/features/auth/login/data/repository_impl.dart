import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remote;
  LoginRepositoryImpl(this.remote);

  @override
  Future<void> login(LoginRequest request) async {
    try {
      await remote.login(LoginRequestModel.fromEntity(request));
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

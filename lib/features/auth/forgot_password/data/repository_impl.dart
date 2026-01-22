import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';
import '../domain/repository.dart';
import 'data_source.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remote;
  ForgotPasswordRepositoryImpl(this.remote);

  @override
  Future<void> sendCode(String email) async {
    try {
      await remote.sendCode(email);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> verifyCode(String email, String code) async {
    try {
      await remote.verifyCode(email, code);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> resetPassword(ForgotPasswordModel request) async {
    try {
      await remote.resetPassword(ForgotPasswordModel.fromEntity(request));
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

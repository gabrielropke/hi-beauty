import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';
import '../domain/repository.dart';
import 'data_source.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterRemoteDataSource remote;
  RegisterRepositoryImpl(this.remote);

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
  Future<void> register(RegisterRequestModel request) async {
    try {
      await remote.register(RegisterRequestModel.fromEntity(request));
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<ReferrerModel> validateReferrerPhone(String phone) async {
    try {
      return await remote.validateReferrerPhone(phone);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

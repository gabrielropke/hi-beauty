import 'dart:convert';

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<void> sendCode(String email);
  Future<void> verifyCode(String email, String code);
  Future<User> resetPassword(ForgotPasswordModel request);
}

class ForgotPasswordRemoteDataSourceImpl extends BaseRemoteDataSource
    implements ForgotPasswordRemoteDataSource {
  ForgotPasswordRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<void> sendCode(String email) async {
    final uri = buildUri('v1/auth/send-verification-code');
    final res = await postJson(
      uri,
      body: {'email': email},
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<void> verifyCode(String email, String code) async {
    final uri = buildUri('v1/auth/verify-code');
    final res = await postJson(
      uri,
      body: {'email': email, 'code': code},
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<User> resetPassword(ForgotPasswordModel request) async {
    final uri = buildUri('v1/auth/reset-password');
    final res = await postJson(
      uri,
      body: request.toMap(),
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    final userData = decoded['user'] as Map<String, dynamic>;
    final sessionData = decoded['session'] as Map<String, dynamic>?;

    final user = User(
      userSessionToken: sessionData?['access_token'] as String? ?? '',
      id: sessionData?['id'] as String? ?? '',
      name: userData['name'] as String? ?? '',
      email: userData['email'] as String? ?? request.email,
    );

    return user;
  }
}

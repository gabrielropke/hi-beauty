import 'dart:convert';

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';

import 'model.dart';

abstract class LoginRemoteDataSource {
  Future<User> login(LoginRequestModel request);
}

class LoginRemoteDataSourceImpl extends BaseRemoteDataSource
    implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<User> login(LoginRequestModel request) async {
    final uri = buildUri('v1/auth/login');
    
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
      email: userData['email'] as String? ?? request.email ?? '',
      whatsapp: userData['whatsapp'] as String?,
    );

    return user;
  }
}

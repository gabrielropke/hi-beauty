import 'dart:convert';
import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/config/brand_loader.dart';

import '../domain/repository.dart';
import 'data_source.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  GoogleAuthRepositoryImpl();

  @override
  Future<User> exchangeIdToken(String idToken) async {
    try {
      final user = await GoogleAuthRemoteDataSourceImpl().exchangeIdToken(
        idToken,
      );

      // Salvar usuário no UserService e SecureStorage como no login/register
      UserService().setUser(user);
      await SecureStorage.saveToken(user.userSessionToken);
      await SecureStorage.saveUser(user);

      return user;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

class GoogleAuthRemoteDataSourceImpl extends BaseRemoteDataSource
    implements GoogleAuthRemoteDataSource {
  GoogleAuthRemoteDataSourceImpl({super.client, super.timeout});

  Future<User> exchangeAccessToken(String token) async {
    final uri = buildUri('v1/auth/google');
    final body = {'idToken': token};

    final res = await postJson(
      uri,
      body: body,
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
      id: userData['id'] as String? ?? '',
      name: userData['name'] as String? ?? '',
      email: userData['email'] as String? ?? '',
      whatsapp: userData['whatsapp'] as String?,
    );

    return user;
  }

  @override
  Future<User> exchangeIdToken(String idToken) {
    return exchangeAccessToken(idToken);
  }
}

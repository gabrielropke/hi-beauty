import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';

abstract class RegisterRemoteDataSource {
  Future<void> sendCode(String email);
  Future<void> verifyCode(String email, String code);
  Future<User> register(RegisterRequestModel request);
  Future<ReferrerModel> validateReferrerPhone(String phone);
}

class RegisterRemoteDataSourceImpl extends BaseRemoteDataSource
    implements RegisterRemoteDataSource {
  RegisterRemoteDataSourceImpl({
    super.client,
    super.baseUrl,
    super.timeout = const Duration(minutes: 5),
  });

  @override
  Future<void> sendCode(String email) async {
    const route = 'v1/auth/send-verification-code';
    dev.log(
      'RegisterRemoteDataSource: Calling route $route',
      name: 'RegisterDataSource',
    );

    final uri = buildUri(route);
    final res = await postJson(
      uri,
      body: {'email': email},
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
      },
    );

    dev.log(
      'RegisterRemoteDataSource: Route $route completed with status ${res.statusCode}',
      name: 'RegisterDataSource',
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<void> verifyCode(String email, String code) async {
    const route = 'v1/auth/verify-code';
    dev.log(
      'RegisterRemoteDataSource: Calling route $route',
      name: 'RegisterDataSource',
    );

    final uri = buildUri(route);
    final res = await postJson(
      uri,
      body: {'email': email, 'code': code},
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
      },
    );

    dev.log(
      'RegisterRemoteDataSource: Route $route completed with status ${res.statusCode}',
      name: 'RegisterDataSource',
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<User> register(RegisterRequestModel request) async {
    const route = 'v1/auth/register';
    dev.log(
      'RegisterRemoteDataSource: Calling route $route',
      name: 'RegisterDataSource',
    );

    try {
      final uri = buildUri(route);

      // Timeout configurado no construtor (5 minutos)
      final res = await postJson(
        uri,
        body: request.toMap(),
        headers: {
          'X-Brand-Id': await BrandLoader.getBrandHeader(),
          'Content-Type': 'application/json',
        },
      );

      dev.log(
        'RegisterRemoteDataSource: Route $route completed with status ${res.statusCode}',
        name: 'RegisterDataSource',
      );

      final apiFailure = ApiFailure.fromResponse(res);
      if (!apiFailure.ok) {
        dev.log(
          'RegisterRemoteDataSource: API failure - ${apiFailure.toString()}',
          name: 'RegisterDataSource',
        );
        throw apiFailure;
      }

      final decoded =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      final userData = decoded['user'] as Map<String, dynamic>;
      final sessionData = decoded['session'] as Map<String, dynamic>?;

      final user = User(
        userSessionToken: sessionData?['access_token'] as String? ?? '',
        id: sessionData?['id'] as String? ?? '',
        name: userData['name'] as String? ?? '',
        email: userData['email'] as String? ?? request.email,
        whatsapp: userData['whatsapp'] as String?,
      );

      return user;
    } catch (e, stackTrace) {
      dev.log(
        'RegisterRemoteDataSource: Error in register - $e',
        name: 'RegisterDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<ReferrerModel> validateReferrerPhone(String phone) async {
    const route = 'v1/auth/validate-referrer-phone';

    try {
      final uri = buildUri(route);

      final res = await postJson(
        uri,
        body: {"phone": phone},
        headers: {
          'accept': 'application/json',
          'X-Brand-Id': await BrandLoader.getBrandHeader(),
          'Content-Type': 'application/json',
        },
      );

      dev.log(
        'RegisterRemoteDataSource: Route $route completed with status ${res.statusCode}',
        name: 'RegisterDataSource',
      );

      // Status 201 é sucesso para esta rota específica
      if (res.statusCode != 200 && res.statusCode != 201) {
        final apiFailure = ApiFailure.fromResponse(res);
        dev.log(
          'RegisterRemoteDataSource: API failure - ${apiFailure.toString()}',
          name: 'RegisterDataSource',
        );
        throw apiFailure;
      }

      final decoded =
          jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

      dev.log(
        'RegisterRemoteDataSource: Response body - $decoded',
        name: 'RegisterDataSource',
      );

      // Verifica se a resposta indica sucesso
      final isSuccess = decoded['success'] as bool? ?? false;

      if (!isSuccess) {
        // Se success é false, trata como erro mesmo com status 201
        final errorMessage = decoded['error'] as String? ?? 'Erro desconhecido';
        throw ApiFailure(message: errorMessage, statusCode: res.statusCode, ok: false);
      }

      final referrerResponse = ReferrerResponse.fromJson(decoded);

      return referrerResponse.data;
    } catch (e, stackTrace) {
      dev.log(
        'RegisterRemoteDataSource: Error in validateReferrerPhone - $e',
        name: 'RegisterDataSource',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow; // Re-propaga o erro para o BLoC tratar
    }
  }
}

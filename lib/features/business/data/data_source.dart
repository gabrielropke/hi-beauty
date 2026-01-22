// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:http_parser/http_parser.dart';

abstract class SetupBusinessRemoteDataSource {
  Future<void> updateSetupBasic(SetupBasicModel body);
  Future<void> updateSetupAddress(SetupAddressModel body);
  Future<void> updateSetupCustomization({
    required String themeColor,
    File? logoImage,
    File? coverImage,
  });
  Future<void> updateBusinessHours(List<OpeningHour> body);
  Future<BusinessRulesResponseModel> getBusinessRules();
  Future<void> updateBusinessRules(BusinessRulesModel body);
  Future<WhatsAppPairingResponse> connectWhatsappMobile({
    required String phone,
  });
  Future<void> disconnectWhatsappMobile();
  Future<void> aiConfig(
    String aiToneOfVoice,
    String aiLanguage,
    String aiVerbosity,
  );
  Future<void> startTrial(String phone, String referrerPhone);
}

class SetupBusinessRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SetupBusinessRemoteDataSource {
  SetupBusinessRemoteDataSourceImpl({
    super.client,
    super.baseUrl,
    super.timeout = const Duration(minutes: 5),
  });

  @override
  Future<void> aiConfig(
    String aiToneOfVoice,
    String aiLanguage,
    String aiVerbosity,
  ) async {
    final uri = buildUri('v1/business/ai-config');
    final res = await patchJson(
      uri,
      body: {
        "aiToneOfVoice": aiToneOfVoice,
        "aiLanguage": aiLanguage,
        "aiVerbosity": aiVerbosity,
      },
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) {
      throw apiFailure;
    }

    return;
  }

  @override
  Future<BusinessRulesResponseModel> getBusinessRules() async {
    final uri = buildUri('v1/business/rules');

    final res = await getJson(
      uri,
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final Map<String, dynamic> data = jsonDecode(res.body);
    return BusinessRulesResponseModel.fromMap(data);
  }

  @override
  Future<void> updateBusinessRules(BusinessRulesModel body) async {
    final uri = buildUri('v1/business/rules');

    final res = await patchJson(
      uri,
      body: body.toJson(),
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<void> startTrial(String phone, String referrerPhone) async {
    final uri = buildUri('v1/auth/update-phone-and-trial');

    final res = await patchJson(
      uri,
      body: {'phone': phone, 'referrerPhone': referrerPhone},
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'Content-Type': 'application/json',
        'accept': 'application/json',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    return;
  }


  @override
  Future<void> updateBusinessHours(List<OpeningHour> body) async {
    final uri = buildUri('v1/business/hours');

    final res = await patchJson(
      uri,
      body: {"openingHours": body.map((e) => e.toJson()).toList()},
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> updateSetupBasic(SetupBasicModel body) async {
    final uri = buildUri('v1/business/setup/basic');
    final res = await patchJson(
      uri,
      body: body.toJson(),
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<void> updateSetupAddress(SetupAddressModel body) async {
    final uri = buildUri('v1/business/setup/address');
    final res = await patchJson(
      uri,
      body: body.toJson(),
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }

  @override
  Future<void> updateSetupCustomization({
    required String themeColor,
    File? logoImage,
    File? coverImage,
  }) async {
    String brandId = await BrandLoader.getBrandHeader();
    String authToken = UserData.userSessionToken;

    final uri = Uri.parse(
      'https://api.zdevs.com.br/v1/business/setup/customization',
    );

    final request = http.MultipartRequest('PATCH', uri);

    // Headers
    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $authToken',
      'X-Brand-Id': brandId,
    });

    // Fields
    request.fields['themeColor'] = themeColor;

    // Logo Image
    if (logoImage != null && await logoImage.exists()) {
      final logoExt = p.extension(logoImage.path).toLowerCase();
      String logoMime = 'image/jpeg';
      if (logoExt == '.png') logoMime = 'image/png';
      if (logoExt == '.webp') logoMime = 'image/webp';

      request.files.add(
        await http.MultipartFile.fromPath(
          'logoImage',
          logoImage.path,
          contentType: MediaType('image', logoMime.split('/')[1]),
        ),
      );
    }

    // Cover Image (mesmo vazio se não existir)
    if (coverImage != null && await coverImage.exists()) {
      final coverExt = p.extension(coverImage.path).toLowerCase();
      String coverMime = 'image/jpeg';
      if (coverExt == '.png') coverMime = 'image/png';
      if (coverExt == '.webp') coverMime = 'image/webp';

      request.files.add(
        await http.MultipartFile.fromPath(
          'coverImage',
          coverImage.path,
          contentType: MediaType('image', coverMime.split('/')[1]),
        ),
      );
    } else {
      // enviar campo vazio para o backend aceitar
      request.fields['coverImage'] = '';
    }

    // Envia a requisição
    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao atualizar customização: ${response.statusCode} - ${response.body}',
      );
    }
  }

  @override
  Future<WhatsAppPairingResponse> connectWhatsappMobile({
    required String phone,
  }) async {
    final uri = buildUri('v1/business/whatsapp/connect-mobile');
    try {
      final res = await postJson(
        uri,
        body: {'whatsapp': phone},
        headers: {
          'X-Brand-Id': await BrandLoader.getBrandHeader(),
          'Authorization': 'Bearer ${UserData.userSessionToken}',
          'accept': 'application/json',
        },
      );

      final apiFailure = ApiFailure.fromResponse(res);
      if (!apiFailure.ok) {
        throw apiFailure;
      }

      final Map<String, dynamic> data = jsonDecode(res.body);
      final response = WhatsAppPairingResponse.fromMap(data);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> disconnectWhatsappMobile() async {
    final uri = buildUri('v1/business/whatsapp/disconnect');

    try {
      final res = await deleteJson(
        uri,
        body: {},
        headers: {
          'X-Brand-Id': await BrandLoader.getBrandHeader(),
          'Authorization': 'Bearer ${UserData.userSessionToken}',
          'accept': 'application/json',
        },
      );

      final apiFailure = ApiFailure.fromResponse(res);
      if (!apiFailure.ok) {
        throw apiFailure;
      }
    } catch (e) {
      rethrow;
    }
  }
}

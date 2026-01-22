import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'model.dart';
// ignore_for_file: depend_on_referenced_packages

abstract class TeamRemoteDataSource {
  Future<TeamResponseModel> getTeam({
    String? search,
    String? status,
    String? role,
    int page,
    int pageSize,
  });
  Future<void> createTeamMember(CreateTeamModel model);
  Future<void> updateTeamMember(String id, CreateTeamModel model);
  Future<void> deleteTeamMember(String id);
}

class TeamRemoteDataSourceImpl extends BaseRemoteDataSource
    implements TeamRemoteDataSource {
  TeamRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<void> deleteTeamMember(String id) async {
    final uri = buildUri('v1/team/$id');

    final res = await deleteJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
      body: {},
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<TeamResponseModel> getTeam({
    String? search,
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) async {
    final queryParams = {
      if (search != null && search.isNotEmpty) 'search': search,
      if (status != null && status.isNotEmpty) 'status': status,
      if (role != null && role.isNotEmpty) 'role': role,
      'page': '$page',
      'pageSize': '$pageSize',
    };

    final uri = buildUri('v1/Team', queryParams);

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return TeamResponseModel.fromJson(decoded);
  }

  @override
  Future<void> updateTeamMember(String id, CreateTeamModel model) async {
    developer.log(
      '[UpdateTeamMember] Iniciando atualização de membro da equipe',
      name: 'TeamDataSource',
    );

    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/team/$id');
      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      // ETAPA 1: PATCH multipart para dados básicos + imagem (sem comissão)
      final request = http.MultipartRequest('PATCH', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos básicos (sem comissão)
      request.fields['name'] = model.name;
      request.fields['email'] = model.email;
      request.fields['phone'] = model.phone;
      request.fields['role'] = model.role;
      request.fields['status'] = model.status;
      request.fields['themeColor'] = model.themeColor;
      request.fields['workingHours'] = jsonEncode(model.workingHours);

      // Imagem (se existir)
      if (model.profileImage != null && await model.profileImage!.exists()) {
        final ext = p.extension(model.profileImage!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            model.profileImage!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
        developer.log(
          '[UpdateTeamMember] Imagem anexada: ${model.profileImage!.path}',
          name: 'TeamDataSource',
        );
      } else {
        request.fields['profileImage'] = '';
      }

      developer.log(
        '[UpdateTeamMember] Enviando PATCH multipart...',
        name: 'TeamDataSource',
      );

      // Envia requisição multipart
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      developer.log(
        '[UpdateTeamMember] Multipart Status: ${response.statusCode}',
        name: 'TeamDataSource',
      );

      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) {
        developer.log(
          '[UpdateTeamMember] ERRO Multipart: ${apiFailure.message}',
          name: 'TeamDataSource',
        );
        throw apiFailure;
      }

      // ETAPA 2: PATCH JSON apenas para comissões (se existir)
      if (model.commissionConfig != null) {
        developer.log(
          '[UpdateTeamMember] Enviando PATCH JSON para comissão...',
          name: 'TeamDataSource',
        );

        final commissionBody = {
          'commissionConfig': model.commissionConfig!.toJson(),
        };

        developer.log(
          '[UpdateTeamMember] CommissionConfig: ${model.commissionConfig!.toJson()}',
          name: 'TeamDataSource',
        );

        final commissionResponse = await http
            .patch(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'accept': 'application/json',
                'Authorization': 'Bearer $authToken',
                'X-Brand-Id': brandId,
              },
              body: jsonEncode(commissionBody),
            )
            .timeout(const Duration(seconds: 30));

        developer.log(
          '[UpdateTeamMember] Commission Status: ${commissionResponse.statusCode}',
          name: 'TeamDataSource',
        );

        final commissionFailure = ApiFailure.fromResponse(commissionResponse);
        if (!commissionFailure.ok) {
          developer.log(
            '[UpdateTeamMember] ERRO Commission: ${commissionFailure.message}',
            name: 'TeamDataSource',
          );
          throw commissionFailure;
        }
      } else {
        developer.log(
          '[UpdateTeamMember] Nenhuma configuração de comissão para enviar',
          name: 'TeamDataSource',
        );
      }

      developer.log(
        '[UpdateTeamMember] Sucesso na atualização completa',
        name: 'TeamDataSource',
      );
    } catch (e, stackTrace) {
      developer.log(
        '[UpdateTeamMember] Exceção: $e',
        name: 'TeamDataSource',
        error: e,
        stackTrace: stackTrace,
      );

      if (e is ApiFailure) {
        // ignore: use_rethrow_when_possible
        throw e;
      }

      throw ApiFailure(
        ok: false,
        message: 'Erro ao atualizar membro da equipe: ${e.toString()}',
        statusCode: 500,
        rawBody: e.toString(),
      );
    }
  }

  @override
  Future<void> createTeamMember(CreateTeamModel model) async {
    developer.log(
      '[CreateTeamMember] Iniciando criação de membro da equipe',
      name: 'TeamDataSource',
    );

    try {
      final uri = Uri.parse('${dotenv.env['API_URL']}/v1/team');
      final brandId = await BrandLoader.getBrandHeader();
      final authToken = UserData.userSessionToken;

      // ETAPA 1: POST multipart para dados básicos + imagem (sem comissão)
      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'accept': 'application/json',
        'Authorization': 'Bearer $authToken',
        'X-Brand-Id': brandId,
      });

      // Campos básicos (sem comissão)
      request.fields['name'] = model.name;
      request.fields['email'] = model.email;
      request.fields['phone'] = model.phone;
      request.fields['role'] = model.role;
      request.fields['status'] = model.status;
      request.fields['themeColor'] = model.themeColor;
      request.fields['workingHours'] = jsonEncode(model.workingHours);

      // Imagem (se existir)
      if (model.profileImage != null && await model.profileImage!.exists()) {
        final ext = p.extension(model.profileImage!.path).toLowerCase();
        String mimeType = 'image/jpeg';
        if (ext == '.png') mimeType = 'image/png';
        if (ext == '.webp') mimeType = 'image/webp';

        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImage',
            model.profileImage!.path,
            contentType: MediaType('image', mimeType.split('/')[1]),
          ),
        );
        developer.log(
          '[CreateTeamMember] Imagem anexada: ${model.profileImage!.path}',
          name: 'TeamDataSource',
        );
      } else {
        request.fields['profileImage'] = '';
      }

      developer.log(
        '[CreateTeamMember] Enviando POST multipart...',
        name: 'TeamDataSource',
      );

      // Envia requisição multipart
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
      );
      final response = await http.Response.fromStream(streamedResponse);

      developer.log(
        '[CreateTeamMember] Multipart Status: ${response.statusCode}',
        name: 'TeamDataSource',
      );

      final apiFailure = ApiFailure.fromResponse(response);
      if (!apiFailure.ok) {
        developer.log(
          '[CreateTeamMember] ERRO Multipart: ${apiFailure.message}',
          name: 'TeamDataSource',
        );
        throw apiFailure;
      }

      // Obter o ID do membro criado
      String? memberId;
      try {
        final responseData = jsonDecode(response.body);
        developer.log(
          '[CreateTeamMember] Response completo: $responseData',
          name: 'TeamDataSource',
        );
        
        if (responseData is Map<String, dynamic>) {
          // Tentar múltiplas variações possíveis do ID
          memberId = responseData['id']?.toString() ?? 
                     responseData['_id']?.toString() ??
                     responseData['memberId']?.toString() ??
                     responseData['teamMemberId']?.toString() ??
                     responseData['data']?['id']?.toString() ??
                     responseData['data']?['_id']?.toString() ??
                     responseData['teamMember']?['id']?.toString() ??  // AQUI ESTAVA O PROBLEMA!
                     responseData['teamMember']?['_id']?.toString();
          
          developer.log(
            '[CreateTeamMember] ID extraído: $memberId',
            name: 'TeamDataSource',
          );
        }
      } catch (e) {
        developer.log(
          '[CreateTeamMember] Erro ao parsear resposta para obter ID: $e',
          name: 'TeamDataSource',
        );
        developer.log(
          '[CreateTeamMember] Response body raw: ${response.body}',
          name: 'TeamDataSource',
        );
      }

      // ETAPA 2: PATCH JSON para comissões (se existir)
      if (model.commissionConfig != null) {
        if (memberId != null) {
          developer.log(
            '[CreateTeamMember] Enviando PATCH JSON para comissão do membro $memberId...',
            name: 'TeamDataSource',
          );

          final patchUri = Uri.parse(
            '${dotenv.env['API_URL']}/v1/team/$memberId',
          );
          final commissionBody = {
            'commissionConfig': model.commissionConfig!.toJson(),
          };

          developer.log(
            '[CreateTeamMember] CommissionConfig: ${model.commissionConfig!.toJson()}',
            name: 'TeamDataSource',
          );

          try {
            final commissionResponse = await http
                .patch(
                  patchUri,
                  headers: {
                    'Content-Type': 'application/json',
                    'accept': 'application/json',
                    'Authorization': 'Bearer $authToken',
                    'X-Brand-Id': brandId,
                  },
                  body: jsonEncode(commissionBody),
                )
                .timeout(const Duration(seconds: 30));

            developer.log(
              '[CreateTeamMember] Commission Status: ${commissionResponse.statusCode}',
              name: 'TeamDataSource',
            );
            developer.log(
              '[CreateTeamMember] Commission Response: ${commissionResponse.body}',
              name: 'TeamDataSource',
            );

            final commissionFailure = ApiFailure.fromResponse(commissionResponse);
            if (!commissionFailure.ok) {
              developer.log(
                '[CreateTeamMember] ERRO Commission: ${commissionFailure.message}',
                name: 'TeamDataSource',
              );
              // IMPORTANTE: Vou propagar o erro da comissão também
              throw ApiFailure(
                ok: false,
                message: 'Membro criado, mas erro ao salvar comissão: ${commissionFailure.message}',
                statusCode: commissionResponse.statusCode,
                rawBody: commissionResponse.body,
              );
            } else {
              developer.log(
                '[CreateTeamMember] Comissão salva com sucesso!',
                name: 'TeamDataSource',
              );
            }
          } catch (e) {
            developer.log(
              '[CreateTeamMember] EXCEÇÃO ao salvar comissão: $e',
              name: 'TeamDataSource',
            );
            throw ApiFailure(
              ok: false,
              message: 'Membro criado, mas erro ao salvar comissão: ${e.toString()}',
              statusCode: 500,
              rawBody: e.toString(),
            );
          }
        } else {
          developer.log(
            '[CreateTeamMember] ERRO CRÍTICO: Não foi possível obter ID para salvar comissão',
            name: 'TeamDataSource',
          );
          throw ApiFailure(
            ok: false,
            message: 'Membro criado, mas não foi possível obter ID para salvar comissão',
            statusCode: 500,
            rawBody: 'ID não encontrado na resposta',
          );
        }
      } else {
        developer.log(
          '[CreateTeamMember] Nenhuma configuração de comissão para enviar',
          name: 'TeamDataSource',
        );
      }

      developer.log(
        '[CreateTeamMember] Sucesso na criação completa',
        name: 'TeamDataSource',
      );
    } catch (e, stackTrace) {
      developer.log(
        '[CreateTeamMember] Exceção: $e',
        name: 'TeamDataSource',
        error: e,
        stackTrace: stackTrace,
      );

      if (e is ApiFailure) {
        // ignore: use_rethrow_when_possible
        throw e;
      }

      throw ApiFailure(
        ok: false,
        message: 'Erro ao criar membro da equipe: ${e.toString()}',
        statusCode: 500,
        rawBody: e.toString(),
      );
    }
  }
}

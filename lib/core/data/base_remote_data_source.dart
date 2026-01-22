import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:http/http.dart' as http;

class RemoteException implements Exception {
  final int? statusCode;
  final String message;
  RemoteException(this.message, {this.statusCode});

  @override
  String toString() => 'RemoteException($statusCode): $message';
}

abstract class BaseRemoteDataSource {
  final http.Client _client;
  final Uri _baseUri;
  final Uri _rawBaseUri;
  final Duration _timeout;
  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
  };

  BaseRemoteDataSource({
    http.Client? client,
    String? baseUrl,
    String? rawUrl,
    Duration timeout = const Duration(seconds: 10),
  }) : _client = client ?? http.Client(),
       _baseUri = Uri.parse(baseUrl ?? dotenv.env['API_URL']!),
       _rawBaseUri = Uri.parse(rawUrl ?? dotenv.env['API_RAW_URL']!),
       _timeout = timeout;

  Future<http.Response> postJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _client
          .post(
            uri,
            headers: {..._jsonHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw RemoteException('Tempo de resposta excedido para ${uri.path}');
    } on SocketException {
      throw RemoteException('Falha de conexão com o servidor em ${uri.host}');
    } on HttpException catch (e) {
      throw RemoteException('Erro HTTP: ${e.message}');
    }
  }

  Future<http.Response> deleteJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _client
          .delete(
            uri,
            headers: {..._jsonHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw RemoteException('Tempo de resposta excedido para ${uri.path}');
    } on SocketException {
      throw RemoteException('Falha de conexão com o servidor em ${uri.host}');
    } on HttpException catch (e) {
      throw RemoteException('Erro HTTP: ${e.message}');
    }
  }

  Future<http.Response> patchJson(
    Uri uri, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _client
          .patch(
            uri,
            headers: {..._jsonHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw RemoteException('Tempo de resposta excedido para ${uri.path}');
    } on SocketException {
      throw RemoteException('Falha de conexão com o servidor em ${uri.host}');
    } on HttpException catch (e) {
      throw RemoteException('Erro HTTP: ${e.message}');
    }
  }

  Future<http.StreamedResponse> patchMultipart(
    Uri uri, {
    required Map<String, String> fields,
    Map<String, File>? files,
    Map<String, String>? headers,
  }) async {
    try {
      final request = http.MultipartRequest('PATCH', uri)
        ..headers.addAll({...?headers})
        ..fields.addAll(fields);

      if (files != null && files.isNotEmpty) {
        for (final entry in files.entries) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      final streamedResponse = await request.send().timeout(_timeout);
      return streamedResponse;
    } on TimeoutException {
      throw RemoteException('Tempo de resposta excedido para ${uri.path}');
    } on SocketException {
      throw RemoteException('Falha de conexão com o servidor em ${uri.host}');
    } on HttpException catch (e) {
      throw RemoteException('Erro HTTP: ${e.message}');
    }
  }

  Future<http.Response> getJson(Uri uri, {Map<String, String>? headers}) async {
    try {
      return await _client
          .get(uri, headers: {..._jsonHeaders, ...?headers})
          .timeout(_timeout);
    } on TimeoutException {
      throw RemoteException('Tempo de resposta excedido para ${uri.path}');
    } on SocketException {
      throw RemoteException('Falha de conexão com o servidor em ${uri.host}');
    } on HttpException catch (e) {
      throw RemoteException('Erro HTTP: ${e.message}');
    }
  }

  void ensureStatus(http.Response res, {Set<int>? expected}) {
    final ok =
        expected?.contains(res.statusCode) ??
        (res.statusCode >= 200 && res.statusCode < 300);

    if (!ok) {
      throw ApiFailure.fromResponse(res);
    }
  }

  Uri buildUri(String path, [Map<String, String>? query]) {
    final nextPath = _join(_baseUri.path, path);
    final mergedQuery = {
      ..._baseUri.queryParameters,
      if (query != null) ...query,
    };
    return _baseUri.replace(path: nextPath, queryParameters: mergedQuery);
  }

  Uri buildUriRaw(String path, [Map<String, String>? query]) {
    final nextPath = _join(_rawBaseUri.path, path);
    final mergedQuery = {
      ..._rawBaseUri.queryParameters,
      if (query != null) ...query,
    };

    return _rawBaseUri.replace(path: nextPath, queryParameters: mergedQuery);
  }

  static String _join(String left, String right) {
    final l = left.endsWith('/') ? left.substring(0, left.length - 1) : left;
    final r = right.startsWith('/') ? right.substring(1) : right;
    return [l, r].where((s) => s.isNotEmpty).join('/');
  }
}

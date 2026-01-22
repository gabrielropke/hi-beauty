import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiFailure implements Exception {
  final bool ok;
  final String message;
  final int statusCode;
  final String? rawBody;

  ApiFailure({
    required this.ok,
    required this.message,
    required this.statusCode,
    this.rawBody,
  });

  factory ApiFailure.fromResponse(http.Response res) {
    final raw = utf8.decode(res.bodyBytes);

    try {
      final decoded = jsonDecode(raw);

      if (decoded is Map<String, dynamic>) {
        final ok = decoded['ok'] == true;

        String msg = '';

        if (decoded.containsKey('message')) {
          if (decoded['message'] is String) {
            msg = decoded['message'];
          } else if (decoded['message'] is List) {
            msg = (decoded['message'] as List).join(', ');
          }
        }

        if (msg.isEmpty && decoded.containsKey('error')) {
          msg = decoded['error'].toString();
        }

        if (msg.isEmpty) msg = 'Erro desconhecido';

        return ApiFailure(
          ok: ok,
          message: msg,
          statusCode: res.statusCode,
          rawBody: raw,
        );
      }
    } catch (_) {}

    return ApiFailure(
      ok: false,
      message: raw.isEmpty ? 'Erro HTTP ${res.statusCode}' : raw,
      statusCode: res.statusCode,
      rawBody: raw,
    );
  }

  @override
  String toString() => '[statusCode: $statusCode] [ok: $ok] message: $message';
}

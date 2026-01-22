import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CepAddress {
  final String logradouro;
  final String bairro;
  final String localidade; 
  final String uf; 

  CepAddress({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory CepAddress.fromMap(Map<String, dynamic> map) {
    return CepAddress(
      logradouro: (map['logradouro'] ?? '').toString(),
      bairro: (map['bairro'] ?? '').toString(),
      localidade: (map['localidade'] ?? '').toString(),
      uf: (map['uf'] ?? '').toString(),
    );
  }
}

class CepService {
  static Future<CepAddress?> getByCep(String cepRaw) async {
    final cep = cepRaw.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) return null;

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    final resp = await http.get(url, headers: {'Accept': 'application/json'});

    if (resp.statusCode != 200) return null;
    final data = json.decode(resp.body);
    if (data is Map && data['erro'] == true) return null;
    return CepAddress.fromMap(data as Map<String, dynamic>);
  }
}

class Debouncer {
  Debouncer({this.milliseconds = 450});
  final int milliseconds;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() => _timer?.cancel();
}
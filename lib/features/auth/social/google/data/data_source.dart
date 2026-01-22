import 'dart:io';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

final String iosClientID = dotenv.env['GOOGLE_CLIENT_ID_IOS']!;
final String androidClientID = dotenv.env['GOOGLE_CLIENT_ID_ANDROID']!;
final String kServerClientId = dotenv.env['GOOGLE_CLIENT_ID_SERVER']!;

abstract class GoogleAuthLocalDataSource {
  Future<void> init();
  Future<GoogleAccountModel?> signIn();
}

class GoogleAuthLocalDataSourceImpl implements GoogleAuthLocalDataSource {
  final gsi.GoogleSignIn _gsi = gsi.GoogleSignIn.instance;

  @override
  Future<void> init() async {
    try {
      print('🔧 [GoogleAuth] Iniciando configuração do Google Sign-In...');
      print('🏷️ [GoogleAuth] iOS Client ID: $iosClientID');
      print('🤖 [GoogleAuth] Android Client ID: $androidClientID');
      print('🖥️ [GoogleAuth] Server Client ID: $kServerClientId');
      
      await _gsi.initialize(
        clientId: Platform.isIOS ? iosClientID : androidClientID,
        serverClientId: kServerClientId,
      );
      
      print('✅ [GoogleAuth] Google Sign-In inicializado com sucesso');
      await _gsi.attemptLightweightAuthentication();
      print('🔑 [GoogleAuth] Tentativa de autenticação leve concluída');
    } catch (e) {
      print('❌ [GoogleAuth] Erro na inicialização: $e');
      debugPrint('[GOOGLE][ERRO] init: $e');
      rethrow;
    }
  }

  @override
  Future<GoogleAccountModel?> signIn() async {
    try {
      final account = await _gsi.authenticate();
      print('✅ [GoogleAuth] Authenticate() concluído');
      print('👤 [GoogleAuth] Account: ${account.displayName} (${account.email})');

      final auth = account.authentication;
      print('🔑 [GoogleAuth] Authentication: ${auth.idToken != null ? "ID Token OK" : "Sem ID Token"}');
      
      developer.log(
        '${account.displayName} is successfully authenticated with Google',
        name: 'Auth',
      );

      return GoogleAccountModel(
        displayName: account.displayName,
        email: account.email,
        photoUrl: account.photoUrl,
        idToken: auth.idToken,
      );
    } catch (e) {
      print('💥 [GoogleAuth] Erro no sign-in: $e');
      developer.log('Signin with Google Error $e', name: 'Auth Error');
      
      // Se foi cancelado pelo usuário, retorna null em vez de rejeitar
      if (e.toString().contains('canceled') || e.toString().contains('cancelled')) {
        return null;
      }
      rethrow;
    }
  }
}

abstract class GoogleAuthRemoteDataSource {
  Future<User> exchangeIdToken(String idToken);
}

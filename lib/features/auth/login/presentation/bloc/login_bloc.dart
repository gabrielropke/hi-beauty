import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/auth/login/data/data_source.dart';
import 'package:hibeauty/features/auth/login/data/model.dart';
import 'package:hibeauty/features/auth/social/google/data/data_source.dart';
import 'package:hibeauty/features/auth/social/google/data/repository_impl.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BuildContext context;
  LoginBloc(this.context) : super(LoginInitial()) {
    on<LoginLoadRequested>(_onLoginLoadedRequested);
    on<ToggleVisiblePassword>(_onToggleVisiblePassword);
    on<CloseMessage>(_onCloseMessage);
    on<SetMessage>(_onSetMessage);
    on<LoginRequest>(_onLoginRequest);
    on<GoogleSignIn>(_onGoogleSignIn);
  }

  Future<void> _onLoginLoadedRequested(
    LoginLoadRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoaded());
  }

  Future<void> _onLoginRequest(
    LoginRequest event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      (state as LoginLoaded).copyWith(
        loginLoading: () => true,
        message: () => '',
      ),
    );

    try {
      final req = LoginRequestModel(
        email: event.email,
        password: event.password,
      );

      final user = await LoginRemoteDataSourceImpl().login(req);

      UserService().setUser(user);
      await SecureStorage.saveToken(user.userSessionToken);
      await SecureStorage.saveUser(user);

      developer.log('User is successfully authenticated', name: 'Auth');

      emit(
        (state as LoginLoaded).copyWith(
          loginLoading: () => false,
          message: () => '',
        ),
      );

      context.go(AppRoutes.home);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as LoginLoaded).copyWith(
            loginLoading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignIn event,
    Emitter<LoginState> emit,
  ) async {
    print('🚀 [GoogleSignIn] Iniciando login com Google...');
    emit(
      (state as LoginLoaded).copyWith(
        googleLoading: () => true,
        message: () => '',
      ),
    );

    try {
      print('📱 [GoogleSignIn] Criando instâncias dos data sources...');
      final google = GoogleAuthLocalDataSourceImpl();
      final googleRepo = GoogleAuthRepositoryImpl();

      print('⚙️ [GoogleSignIn] Inicializando Google Sign In...');
      await google.init();
      
      print('👤 [GoogleSignIn] Tentando fazer sign in...');
      final account = await google.signIn();

      if (account == null) {
        print('⚠️ [GoogleSignIn] Login cancelado pelo usuário (retornando sem erro)');
        emit(
          (state as LoginLoaded).copyWith(
            googleLoading: () => false,
            message: () => '',
          ),
        );
        return; // Retorna sem erro quando cancelado
      }

      print('✅ [GoogleSignIn] Account obtida: ${account.email}');
      print('🔑 [GoogleSignIn] Verificando idToken...');
      
      final idToken = account.idToken;
      if (idToken == null || idToken.isEmpty) {
        print('❌ [GoogleSignIn] ID Token não disponível ou vazio');
        throw Exception('ID Token não disponível');
      }

      print('🔄 [GoogleSignIn] Fazendo exchange do idToken...');
      final jwt = await googleRepo.exchangeIdToken(idToken);

      print('👤 [GoogleSignIn] Criando objeto User...');
      final user = User(
        userSessionToken: jwt.userSessionToken,
        name: account.displayName,
        email: account.email,
        profileImageUrl: account.photoUrl,
      );

      print('💾 [GoogleSignIn] Salvando dados do usuário...');
      UserService().setUser(user);
      await SecureStorage.saveToken(user.userSessionToken);
      await SecureStorage.saveUser(user);

      developer.log(
        'User is successfully authenticated with Google',
        name: 'Auth',
      );

      print('✨ [GoogleSignIn] Login com Google concluído com sucesso!');
      emit(
        (state as LoginLoaded).copyWith(
          googleLoading: () => false,
          message: () => '',
        ),
      );

      context.go(AppRoutes.home);
    } catch (e) {
      print('💥 [GoogleSignIn] Erro no login com Google: $e');
      if (e is ApiFailure) {
        emit(
          (state as LoginLoaded).copyWith(
            googleLoading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }

      emit(
        (state as LoginLoaded).copyWith(
          googleLoading: () => false,
          message: () => 'Erro ao fazer login com Google: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<LoginState> emit,
  ) async {
    emit((state as LoginLoaded).copyWith(message: () => ''));
  }

  Future<void> _onSetMessage(SetMessage event, Emitter<LoginState> emit) async {
    emit((state as LoginLoaded).copyWith(message: () => event.value));
  }

  Future<void> _onToggleVisiblePassword(
    ToggleVisiblePassword event,
    Emitter<LoginState> emit,
  ) async {
    emit((state as LoginLoaded).copyWith(obscureText: () => event.value));
  }
}

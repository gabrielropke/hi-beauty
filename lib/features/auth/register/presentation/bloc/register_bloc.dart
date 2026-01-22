import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/auth/components/requirements_box.dart';
import 'package:hibeauty/features/auth/components/timer.dart';
import 'package:hibeauty/features/auth/register/data/data_source.dart';
import 'package:hibeauty/features/auth/register/data/model.dart';
import 'package:hibeauty/features/auth/social/google/data/data_source.dart';
import 'package:hibeauty/features/auth/social/google/data/repository_impl.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final BuildContext context;
  RegisterBloc(this.context) : super(RegisterInitial()) {
    on<RegisterLoadRequested>(_onRegisterLoadedRequested);
    on<ToggleVisiblePassword>(_onToggleVisiblePassword);
    on<PasswordChanged>(_onPasswordChanged);
    on<VerifyCodeRequested>(_onVerifyCodeRequested);
    on<StartTimer>(_onStartTimer);
    on<SendCodeRequested>(_onSendCodeRequested);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<ValidateReferrerPhone>(_onValidateReferrerPhone);
    on<EnableIndicator>(_onEnableIndicator);
  }

  Future<void> _onRegisterLoadedRequested(
    RegisterLoadRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      RegisterLoaded(
        timerController: TimerController(initialTime: 120),
        timerActive: true,
        seconds: 120,
        registerLoading: false,
      ),
    );
  }

  Future<void> _onGoogleSignIn(
    GoogleSignIn event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      (state as RegisterLoaded).copyWith(
        googleLoading: () => true,
        message: () => '',
      ),
    );

    try {
      final google = GoogleAuthLocalDataSourceImpl();
      final googleRepo = GoogleAuthRepositoryImpl();

      await google.init();
      final account = await google.signIn();

      if (account == null || account.idToken == null) {
        throw Exception('Register cancelado ou sem idToken');
      }

      final idToken = account.idToken;
      if (idToken == null) {
        throw Exception('ID Token não disponível');
      }

      final jwt = await googleRepo.exchangeIdToken(idToken);

      final user = User(
        userSessionToken: jwt.userSessionToken,
        name: account.displayName,
        email: account.email,
        profileImageUrl: account.photoUrl,
      );

      UserService().setUser(user);
      await SecureStorage.saveToken(user.userSessionToken);
      await SecureStorage.saveUser(user);

      developer.log(
        'User is successfully authenticated with Google',
        name: 'Auth',
      );

      emit(
        (state as RegisterLoaded).copyWith(
          googleLoading: () => false,
          message: () => '',
        ),
      );

      context.go(AppRoutes.home);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as RegisterLoaded).copyWith(
            googleLoading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }

      emit(
        (state as RegisterLoaded).copyWith(
          googleLoading: () => false,
          message: () => 'Erro ao fazer Register com Google',
        ),
      );
    }
  }

  Future<void> _onSendCodeRequested(
    SendCodeRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      (state as RegisterLoaded).copyWith(
        registerLoading: () => true,
        message: () => '',
      ),
    );

    try {
      await RegisterRemoteDataSourceImpl().sendCode(event.args.email);

      emit(
        (state as RegisterLoaded).copyWith(
          registerLoading: () => false,
          message: () => '',
        ),
      );

      context.go(AppRoutes.registerEnterCode, extra: event.args);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as RegisterLoaded).copyWith(
            registerLoading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onVerifyCodeRequested(
    VerifyCodeRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      (state as RegisterLoaded).copyWith(
        registerLoading: () => true,
        message: () => '',
      ),
    );

    try {
      await RegisterRemoteDataSourceImpl().verifyCode(
        event.args.email,
        event.args.emailCode,
      );

      final user = await RegisterRemoteDataSourceImpl().register(event.args);

      UserService().setUser(
        User(
          userSessionToken: user.userSessionToken,
          id: user.id,
          name: user.name,
          email: user.email,
          whatsapp: user.whatsapp,
        ),
      );

      await SecureStorage.saveToken(user.userSessionToken);

      await SecureStorage.saveUser(user);

      emit(
        (state as RegisterLoaded).copyWith(
          registerLoading: () => false,
          message: () => '',
        ),
      );

      context.go(AppRoutes.home);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as RegisterLoaded).copyWith(
            registerLoading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onValidateReferrerPhone(
    ValidateReferrerPhone event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      (state as RegisterLoaded).copyWith(
        registerLoading: () => false,
        referrerMessage: () => '',
      ),
    );

    try {
      final referrer = await RegisterRemoteDataSourceImpl()
          .validateReferrerPhone(event.phone);

      emit(
        (state as RegisterLoaded).copyWith(
          registerLoading: () => false,
          referrerMessage: () => '',
          referrerInfo: () => referrer,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as RegisterLoaded).copyWith(
            registerLoading: () => false,
            referrerMessage: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onToggleVisiblePassword(
    ToggleVisiblePassword event,
    Emitter<RegisterState> emit,
  ) async {
    emit((state as RegisterLoaded).copyWith(obscureText: () => event.value));
  }

  Future<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<RegisterState> emit,
  ) async {
    final current = state;
    if (current is RegisterLoaded) {
      emit(current.copyWith(password: () => event.value, message: () => ''));
    }
  }

  Future<void> _onEnableIndicator(
    EnableIndicator event,
    Emitter<RegisterState> emit,
  ) async {
    final current = state;
    if (current is RegisterLoaded) {
      emit(
        current.copyWith(
          indicatorEnabled: () => event.value,
          referrerInfo: event.value == false
              ? () => ReferrerModel(referrerName: '', referrerPhone: '')
              : () => current.referrerInfo,
        ),
      );
    }
  }

  Future<void> _onStartTimer(
    StartTimer event,
    Emitter<RegisterState> emit,
  ) async {
    emit(
      (state as RegisterLoaded).copyWith(
        timerController: () => TimerController(initialTime: 120),
        timerActive: () => true,
        seconds: () => 120,
        message: () => '',
      ),
    );
  }
}

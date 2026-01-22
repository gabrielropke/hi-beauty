import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/features/auth/components/requirements_box.dart';
import 'package:hibeauty/features/auth/components/timer.dart';
import 'package:hibeauty/features/auth/forgot_password/data/data_source.dart';
import 'package:hibeauty/features/auth/forgot_password/data/model.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final BuildContext context;
  ForgotPasswordBloc(this.context) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordLoadRequested>(_onForgotPasswordLoadedRequested);
    on<ToggleVisiblePassword>(_onToggleVisiblePassword);
    on<VerifyCodeRequested>(_onVerifyCodeRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SendCodeRequested>(_onSendCodeRequested);
    on<StartTimer>(_onStartTimer);
    on<PasswordChanged>(_onPasswordChanged);
    on<ResetPasswordRequest>(_onResetPasswordRequest);
  }

  Future<void> _onForgotPasswordLoadedRequested(
    ForgotPasswordLoadRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      ForgotPasswordLoaded(
        timerController: TimerController(initialTime: 120),
        timerActive: true,
        seconds: 120,
        loading: false,
      ),
    );
  }

  Future<void> _onResetPasswordRequest(
    ResetPasswordRequest event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(
        loading: () => true,
        message: () => const {'': ''},
      ),
    );

    try {
      await ForgotPasswordRemoteDataSourceImpl().resetPassword(event.args);

      emit((state as ForgotPasswordLoaded).copyWith(loading: () => false));

      context.go(AppRoutes.login);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as ForgotPasswordLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onSendCodeRequested(
    SendCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(
        loading: () => true,
        message: () => const {'': ''},
      ),
    );

    try {
      await ForgotPasswordRemoteDataSourceImpl().sendCode(event.args.email);

      emit((state as ForgotPasswordLoaded).copyWith(loading: () => false));

      context.push(AppRoutes.forgotPasswordEnterCode, extra: event.args);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as ForgotPasswordLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onVerifyCodeRequested(
    VerifyCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(
        loading: () => true,
        message: () => const {'': ''},
      ),
    );

    try {
      await ForgotPasswordRemoteDataSourceImpl().verifyCode(
        event.args.email,
        event.args.emailCode,
      );
      
      context.go(AppRoutes.newPassword, extra: event.args);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as ForgotPasswordLoaded).copyWith(
            loading: () => false,
            message: () => {'error': e.message},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(message: () => const {'': ''}),
    );
  }

  Future<void> _onToggleVisiblePassword(
    ToggleVisiblePassword event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(obscureText: () => event.value),
    );
  }

  Future<void> _onStartTimer(
    StartTimer event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(
        timerController: () => TimerController(initialTime: 120),
        timerActive: () => true,
        seconds: () => 120,
        message: () => const {'': ''},
      ),
    );
  }

  Future<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(
      (state as ForgotPasswordLoaded).copyWith(
        password: () => event.value,
        message: () => const {'': ''},
      ),
    );
  }
}

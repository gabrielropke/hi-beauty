import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/subscription.dart';
import 'package:hibeauty/core/services/subscription/data/data_source.dart';
import 'package:hibeauty/core/services/subscription/data/model.dart';
import 'package:hibeauty/features/team/data/data_source.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:url_launcher/url_launcher.dart';

part 'signature_event.dart';
part 'signature_state.dart';

class SignatureBloc extends Bloc<SignatureEvent, SignatureState> {
  final BuildContext context;
  SignatureBloc(this.context) : super(SignatureInitial()) {
    on<SignatureLoadRequested>(_onSignatureLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SetMessage>(_onSetMessage);
    on<CreateCheckout>(_onCreateCheckout);
    on<CancelSignature>(_onCancelSignature);
    on<ReactivateSignature>(_onReactivateSignature);
  }

  Future<void> _onSignatureLoadedRequested(
    SignatureLoadRequested event,
    Emitter<SignatureState> emit,
  ) async {
    emit(SignatureLoading());
    try {
      final team = await TeamRemoteDataSourceImpl().getTeam();
      final subscription = await SubscriptionRemoteDataSourceImpl()
          .getMySubscription();
      emit(SignatureLoaded(team: team, subscription: subscription));
    } catch (e) {
      // Se falhar ao carregar subscription, carrega só o team
      try {
        final team = await TeamRemoteDataSourceImpl().getTeam();
        emit(SignatureLoaded(team: team, subscription: null));
      } catch (e) {
        emit(SignatureFailure());
      }
    }
  }

  Future<void> _onReactivateSignature(
    ReactivateSignature event,
    Emitter<SignatureState> emit,
  ) async {
    emit(
      (state as SignatureLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SubscriptionRemoteDataSourceImpl().reactivateSubscription();
      await SubscriptionService().refresh();
      final subscription = await SubscriptionRemoteDataSourceImpl()
          .getMySubscription();

      developer.log('Signature reactivated successfully', name: 'Signature');

      AppFloatingMessage.show(
        context,
        message: 'A assinatura foi reativada',
        type: AppFloatingMessageType.success,
      );

      emit(
        (state as SignatureLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
          subscription: () => subscription,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        emit(
          (state as SignatureLoaded).copyWith(
            loading: () => false,
            message: () => {'': ''},
          ),
        );
        return;
      }
    }
  }


  Future<void> _onCancelSignature(
    CancelSignature event,
    Emitter<SignatureState> emit,
  ) async {
    emit(
      (state as SignatureLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SubscriptionRemoteDataSourceImpl().deleteSubscription();
      await SubscriptionService().refresh();
      final subscription = await SubscriptionRemoteDataSourceImpl()
          .getMySubscription();

      developer.log('Signature canceled successfully', name: 'Signature');

      AppFloatingMessage.show(
        context,
        message: 'A assinatura será cancelada ao final do período atual',
        type: AppFloatingMessageType.success,
      );

      emit(
        (state as SignatureLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
          subscription: () => subscription,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        emit(
          (state as SignatureLoaded).copyWith(
            loading: () => false,
            message: () => {'': ''},
          ),
        );
        return;
      }
    }
  }

  Future<void> _onCreateCheckout(
    CreateCheckout event,
    Emitter<SignatureState> emit,
  ) async {
    emit(
      (state as SignatureLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      final checkout = await SubscriptionRemoteDataSourceImpl()
          .createCheckoutSession();

      // 🔓 Remove loading antes de sair do app
      emit(
        (state as SignatureLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );

      // 🌍 Abre Stripe Checkout fora do app
      await launchUrl(
        Uri.parse(checkout.url),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      emit(
        (state as SignatureLoaded).copyWith(
          loading: () => false,
          message: () => {
            'error':
                'Não foi possível iniciar o checkout. Tente novamente mais tarde.',
          },
        ),
      );
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<SignatureState> emit,
  ) async {
    emit((state as SignatureLoaded).copyWith(message: () => {'': ''}));
  }

  Future<void> _onSetMessage(
    SetMessage event,
    Emitter<SignatureState> emit,
  ) async {
    emit((state as SignatureLoaded).copyWith(message: () => event.message));
  }
}

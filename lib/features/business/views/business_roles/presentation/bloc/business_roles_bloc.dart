import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/features/business/data/data_source.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

part 'business_roles_event.dart';
part 'business_roles_state.dart';

class BusinessRolesBloc extends Bloc<BusinessRolesEvent, BusinessRolesState> {
  final BuildContext context;
  BusinessRolesBloc(this.context) : super(BusinessRolesBusinessRoles()) {
    on<BusinessRolesLoadRequested>(_onBusinessRolesLoadedRequested);
    on<BusinessRulesSaveRequested>(_onBusinessRulesSaveRequested);
    on<CloseMessage>(_onCloseMessage);
  }

  Future<void> _onBusinessRolesLoadedRequested(
    BusinessRolesLoadRequested event,
    Emitter<BusinessRolesState> emit,
  ) async {
    final roles = await SetupBusinessRemoteDataSourceImpl().getBusinessRules();

    emit(BusinessRolesLoaded(roles: roles));
  }

  Future<void> _onBusinessRulesSaveRequested(
    BusinessRulesSaveRequested event,
    Emitter<BusinessRolesState> emit,
  ) async {
    if (state is BusinessRolesLoaded) {
      final currentState = state as BusinessRolesLoaded;
      emit(currentState.copyWith(loading: () => true));

      try {
        await SetupBusinessRemoteDataSourceImpl().updateBusinessRules(
          event.businessRules,
        );

        // Recarregar dados atualizados
        final updatedRoles = await SetupBusinessRemoteDataSourceImpl()
            .getBusinessRules();

        emit(BusinessRolesLoaded(roles: updatedRoles, loading: false));

        AppFloatingMessage.show(
          context,
          message: AppLocalizations.of(context)!.messageSuccess,
          type: AppFloatingMessageType.success,
        );
      } catch (e) {
        if (e is ApiFailure) {
          emit(currentState.copyWith(loading: () => false));
          AppFloatingMessage.show(
            context,
            message: e.message,
            type: AppFloatingMessageType.error,
          );
          return;
        }
      }
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<BusinessRolesState> emit,
  ) async {
    emit((state as BusinessRolesLoaded).copyWith(message: () => ''));
  }
}

import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/features/business/data/data_source.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';
import 'package:hibeauty/features/team/data/data_source.dart';
import 'package:hibeauty/features/team/data/model.dart';

part 'business_hours_event.dart';
part 'business_hours_state.dart';

class BusinessHoursBloc extends Bloc<BusinessHoursEvent, BusinessHoursState> {
  final BuildContext context;
  BusinessHoursBloc(this.context) : super(BusinessHoursBusinessHours()) {
    on<BusinessHoursLoadRequested>(_onBusinessHoursLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<BusinessHoursSave>(_onBusinessHoursSave);
    on<SetLocalUpdateHours>(_onSetLocalUpdateHours);
    on<UpdateTeamMember>(_onUpdateTeamMember);
  }

  Future<void> _onBusinessHoursLoadedRequested(
    BusinessHoursLoadRequested event,
    Emitter<BusinessHoursState> emit,
  ) async {
    final team = await TeamRemoteDataSourceImpl().getTeam();

    emit(
      BusinessHoursLoaded(
        teamMembers: team.teamMembers,
        openingHours: BusinessData.openingHours,
      ),
    );
  }

  Future<void> _onUpdateTeamMember(
    UpdateTeamMember event,
    Emitter<BusinessHoursState> emit,
  ) async {
    emit(
      (state as BusinessHoursLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await TeamRemoteDataSourceImpl().updateTeamMember(event.id, event.body);
      final team = await TeamRemoteDataSourceImpl().getTeam();

      developer.log('Member updated successfully', name: 'Team Members');

      AppFloatingMessage.show(
        context,
        message: 'Colaborador(a) atualizado(a) com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as BusinessHoursLoaded).copyWith(
          loading: () => false,
          message: () => '',
          teamMembers: () => team.teamMembers,
        ),
      );
      // dispara reload para garantir estado sincronizado (ex: outros dados afetados)
      add(BusinessHoursLoadRequested());
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
        context,
        message:e.message,
        type: AppFloatingMessageType.error,
      );
        emit(
          (state as BusinessHoursLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onBusinessHoursSave(
    BusinessHoursSave event,
    Emitter<BusinessHoursState> emit,
  ) async {
    emit(
      (state as BusinessHoursLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().updateBusinessHours(
        (state as BusinessHoursLoaded).openingHours,
      );
      developer.log('Business hours updated successfully.', name: 'Business');

      final currentBusiness = BusinessService().currentBusiness;
      if (currentBusiness != null) {
        final updatedBusiness = currentBusiness.copyWith(
          openingHours: event.body,
        );

        BusinessService().setBusiness(updatedBusiness);
        await SecureStorage.saveBusiness(updatedBusiness);
      }

      AppFloatingMessage.show(
        context,
        message: 'Horários atualizados com sucesso',
        type: AppFloatingMessageType.success,
      );

      emit(
        (state as BusinessHoursLoaded).copyWith(
          loading: () => false,
          message: () => '',
          openingHours: () => event.body,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as BusinessHoursLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      }
      emit(
        (state as BusinessHoursLoaded).copyWith(
          loading: () => false,
          message: () => 'Erro inesperado',
        ),
      );
      AppFloatingMessage.show(
        context,
        message: 'Erro inesperado',
        type: AppFloatingMessageType.error,
      );
    }
  }

  Future<void> _onSetLocalUpdateHours(
    SetLocalUpdateHours event,
    Emitter<BusinessHoursState> emit,
  ) async {
    emit(
      (state as BusinessHoursLoaded).copyWith(
        openingHours: () => event.updatedHours,
      ),
    );
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<BusinessHoursState> emit,
  ) async {
    emit((state as BusinessHoursLoaded).copyWith(message: () => ''));
  }
}

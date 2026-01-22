import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/features/team/data/data_source.dart';
import 'package:hibeauty/features/team/data/model.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final BuildContext context;
  TeamBloc(this.context) : super(TeamTeam()) {
    on<TeamLoadRequested>(_onTeamLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<CreateTeamMember>(_onCreateTeamMember);
    on<DeleteTeamMember>(_onDeleteTeamMember);
    on<UpdateTeamMember>(_onUpdateTeamMember);
  }

  Future<void> _onTeamLoadedRequested(
    TeamLoadRequested event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoading());
    final team = await TeamRemoteDataSourceImpl().getTeam();

    emit(TeamLoaded(team: team));
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<TeamState> emit,
  ) async {
    emit((state as TeamLoaded).copyWith(message: () => ''));
  }

  Future<void> _onDeleteTeamMember(
    DeleteTeamMember event,
    Emitter<TeamState> emit,
  ) async {
    emit(
      (state as TeamLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await TeamRemoteDataSourceImpl().deleteTeamMember(event.id);
      final team = await TeamRemoteDataSourceImpl().getTeam();

      developer.log('Member deleted successfully', name: 'Team Members');

      AppFloatingMessage.show(
        context,
        message: 'Colaborador(a) excluído(a) com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as TeamLoaded).copyWith(
          loading: () => false,
          message: () => '',
          team: () => team,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
        context,
        message:e.message,
        type: AppFloatingMessageType.error,
      );
        emit(
          (state as TeamLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onUpdateTeamMember(
    UpdateTeamMember event,
    Emitter<TeamState> emit,
  ) async {
    emit(
      (state as TeamLoaded).copyWith(
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
        (state as TeamLoaded).copyWith(
          loading: () => false,
          message: () => '',
          team: () => team,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
        context,
        message:e.message,
        type: AppFloatingMessageType.error,
      );
        emit(
          (state as TeamLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onCreateTeamMember(
    CreateTeamMember event,
    Emitter<TeamState> emit,
  ) async {
    emit(
      (state as TeamLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await TeamRemoteDataSourceImpl().createTeamMember(event.body);
      final team = await TeamRemoteDataSourceImpl().getTeam();

      developer.log('Member created with successfuly', name: 'Team Members');

      AppFloatingMessage.show(
        context,
        message: 'Colaborador(a) criado(a) com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as TeamLoaded).copyWith(
          loading: () => false,
          message: () => '',
          team: () => team,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
        context,
        message:e.message,
        type: AppFloatingMessageType.error,
      );
        emit(
          (state as TeamLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

}

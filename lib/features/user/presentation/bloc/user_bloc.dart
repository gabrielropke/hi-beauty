import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final BuildContext context;
  UserBloc(this.context) : super(UserInitial()) {
    on<UserLoadRequested>(_onUserLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SetMessage>(_onSetMessage);
  }

  Future<void> _onUserLoadedRequested(
    UserLoadRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoaded());
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<UserState> emit,
  ) async {
    emit((state as UserLoaded).copyWith(message: () => {'': ''}));
  }

  Future<void> _onSetMessage(
    SetMessage event,
    Emitter<UserState> emit,
  ) async {
    emit((state as UserLoaded).copyWith(message: () => event.message));
  }
}

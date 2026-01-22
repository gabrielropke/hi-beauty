import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'functions_event.dart';
part 'functions_state.dart';

class FunctionsBloc extends Bloc<FunctionsEvent, FunctionsState> {
  final BuildContext context;
  FunctionsBloc(this.context) : super(FunctionsInitial()) {
    on<FunctionsLoadRequested>(_onFunctionsLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SetMessage>(_onSetMessage);
  }

  Future<void> _onFunctionsLoadedRequested(
    FunctionsLoadRequested event,
    Emitter<FunctionsState> emit,
  ) async {
    emit(FunctionsLoaded());
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<FunctionsState> emit,
  ) async {
    emit((state as FunctionsLoaded).copyWith(message: () => {'': ''}));
  }

  Future<void> _onSetMessage(
    SetMessage event,
    Emitter<FunctionsState> emit,
  ) async {
    emit((state as FunctionsLoaded).copyWith(message: () => event.message));
  }
}

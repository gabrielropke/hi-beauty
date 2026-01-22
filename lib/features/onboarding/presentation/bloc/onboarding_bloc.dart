import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/services/business_options/data/data_source.dart';
import 'package:hibeauty/core/services/business_options/data/model.dart';
import 'package:hibeauty/features/onboarding/data/setup/data_source.dart';
import 'package:hibeauty/features/onboarding/data/setup/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final BuildContext context;
  OnboardingBloc(this.context) : super(OnboardingInitial()) {
    on<OnboardingLoadRequested>(_onOnboardingLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SetMessage>(_onSetMessage);
    on<AdvanceStep>(_onAdvanceStep);
    on<BackStep>(_onBackStep);
    on<SelectSubSegment>(_onSelectSubSegment);
    on<SelectTeamSize>(_onSelectTeamSize);
    on<SelectMainObjective>(_onSelectMainObjective);
    on<CreateSetupBasic>(_onCreateSetupBasic);
  }

  Future<void> _onOnboardingLoadedRequested(
    OnboardingLoadRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(OnboardingLoading());

    try {
      final req = BusinessOptionsRemoteDataSourceImpl();
      final teamSizes = await req.getTeamSize();
      final mainObjectives = await req.getMainObjectives();

      final brand = await BrandLoader.load();
      final rawSegments = brand['segments'] as List<dynamic>? ?? [];

      // Agora mapeia para SegmentModel
      final segments = rawSegments
          .map((e) => SubSegmentsModel.fromJson(e as Map<String, dynamic>))
          .toList();

      emit(
        OnboardingLoaded(
          subsegments: segments, // se quiser renomear o campo, pode mudar
          mainObjectives: mainObjectives,
          teamSize: teamSizes,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(OnboardingLoaded(loading: false));
        return;
      }
    }
  }

  Future<void> _onCreateSetupBasic(
    CreateSetupBasic event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      (state as OnboardingLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    try {
      await SetupBusinessRemoteDataSourceImpl().createSetupBasic(event.body);
      developer.log('Business registered with successfuly', name: 'Business');

      // Marca que o usuário completou o onboarding
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('from_onboarding', true);

      emit(
        (state as OnboardingLoaded).copyWith(
          loading: () => false,
          message: () => {'': ''},
        ),
      );

      context.go(AppRoutes.home);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as OnboardingLoaded).copyWith(
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
    Emitter<OnboardingState> emit,
  ) async {
    emit((state as OnboardingLoaded).copyWith(message: () => {'': ''}));
  }

  Future<void> _onSetMessage(
    SetMessage event,
    Emitter<OnboardingState> emit,
  ) async {
    emit((state as OnboardingLoaded).copyWith(message: () => event.message));
  }

  Future<void> _onAdvanceStep(
    AdvanceStep event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;
    final steps = Steps.values;
    Steps next = current.step;

    if (event.to != null) {
      next = event.to!;
    } else {
      final idx = steps.indexOf(current.step);
      if (idx < steps.length - 1) {
        next = steps[idx + 1];
      }
    }

    if (next == current.step) return;
    emit(current.copyWith(step: () => next));
  }

  Future<void> _onBackStep(
    BackStep event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;
    final idx = Steps.values.indexOf(current.step);
    if (idx <= 0) return;
    final prev = Steps.values[idx - 1];
    emit(current.copyWith(step: () => prev));
  }

  Future<void> _onSelectTeamSize(
    SelectTeamSize event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;
    emit(current.copyWith(selectedTeamSizeKey: () => event.teamSizeKey));
  }

  Future<void> _onSelectMainObjective(
    SelectMainObjective event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;
    emit(
      current.copyWith(selectedMainObjectiveKey: () => event.mainObjectiveKey),
    );
  }

  Future<void> _onSelectSubSegment(
    SelectSubSegment event,
    Emitter<OnboardingState> emit,
  ) async {
    final current = state;
    if (current is! OnboardingLoaded) return;

    final selected = List<String>.from(current.selectedSubSegmentKey ?? []);

    if (selected.contains(event.subSegmentKey)) {
      selected.remove(event.subSegmentKey);
    } else {
      selected.add(event.subSegmentKey);
    }

    emit(current.copyWith(selectedSubSegmentKey: () => selected));
  }
}

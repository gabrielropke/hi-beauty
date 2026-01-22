import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/schedules/data/data_source.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/team/data/data_source.dart';
import 'package:hibeauty/features/team/data/model.dart';

part 'schedules_event.dart';
part 'schedules_state.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  final BuildContext context;
  SchedulesBloc(this.context) : super(SchedulesInitial()) {
    on<SchedulesLoadRequested>(_onSchedulesLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SelectDate>(_onSelectDate);
    on<SelectTimelineType>(_onSelectTimelineType);
  }

  Future<void> _onSchedulesLoadedRequested(
    SchedulesLoadRequested event,
    Emitter<SchedulesState> emit,
  ) async {
    emit(SchedulesLoading());
    final team = await TeamRemoteDataSourceImpl().getTeam();
    final dateString = DateTime.now().toIso8601String().split('T').first;
    final schedules = await SchedulesRemoteDataSourceImpl().getSchedulesDay(
      date: dateString,
    );
    emit(
      SchedulesLoaded(
        team: team,
        date: DateTime.now(),
        booking: schedules.bookings,
      ),
    );
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<SchedulesState> emit,
  ) async {
    emit((state as SchedulesLoaded).copyWith(message: () => ''));
  }

  Future<void> _onSelectTimelineType(
    SelectTimelineType event,
    Emitter<SchedulesState> emit,
  ) async {
    final currentState = state as SchedulesLoaded;
    final selectedDate = event.date ?? currentState.date;
    final dateString = selectedDate.toIso8601String().split('T').first;
    
    if (event.timelineType == TimeLineType.day) {
      final day = await SchedulesRemoteDataSourceImpl().getSchedulesDay(
        date: dateString,
      );
      emit(
        currentState.copyWith(
          timelineType: () => event.timelineType,
          booking: () => day.bookings,
          bookingWeekOrMonth: () => null,
          date: () => selectedDate,
        ),
      );
    } else if (event.timelineType == TimeLineType.threeDays ||
        event.timelineType == TimeLineType.week) {
      final week = await SchedulesRemoteDataSourceImpl().getSchedulesWeek(
        date: dateString,
      );
      emit(
        currentState.copyWith(
          timelineType: () => event.timelineType,
          booking: () => null,
          bookingWeekOrMonth: () => week,
          date: () => selectedDate,
        ),
      );
    } else {
      final month = await SchedulesRemoteDataSourceImpl().getSchedulesMonth(
        date: dateString,
      );
      emit(
        currentState.copyWith(
          timelineType: () => event.timelineType,
          booking: () => null,
          bookingWeekOrMonth: () => month,
          date: () => selectedDate,
        ),
      );
    }
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<SchedulesState> emit,
  ) async {
    emit((state as SchedulesLoaded).copyWith(loading: () => true));

    final currentState = state as SchedulesLoaded;
    final dateString = event.date.toIso8601String().split('T').first;

    if (currentState.timelineType == TimeLineType.day) {
      final schedules = await SchedulesRemoteDataSourceImpl().getSchedulesDay(
        date: dateString,
      );
      emit(
        currentState.copyWith(
          date: () => event.date,
          loading: () => false,
          booking: () => schedules.bookings,
          bookingWeekOrMonth: () => null,
        ),
      );
    } else if (currentState.timelineType == TimeLineType.week ||
        currentState.timelineType == TimeLineType.threeDays) {
      final schedules = await SchedulesRemoteDataSourceImpl().getSchedulesWeek(
        date: dateString,
      );
      emit(
        currentState.copyWith(
          date: () => event.date,
          loading: () => false,
          booking: () => null,
          bookingWeekOrMonth: () => schedules,
        ),
      );
    } else {
      final schedules = await SchedulesRemoteDataSourceImpl().getSchedulesMonth(
        date: dateString,
      );
      emit(
        currentState.copyWith(
          date: () => event.date,
          loading: () => false,
          booking: () => null,
          bookingWeekOrMonth: () => schedules,
        ),
      );
    }
  }
}

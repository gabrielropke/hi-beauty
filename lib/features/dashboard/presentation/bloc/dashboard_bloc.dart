import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/dashboard/data/data_source.dart';
import 'package:hibeauty/features/dashboard/data/model.dart';
import 'package:hibeauty/features/dashboard/data/repository_impl.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final BuildContext context;
  DashboardBloc(this.context) : super(DashboardDashboard()) {
    on<DashboardLoadRequested>(_onDashboardLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<UpdatePeriodDashboard>(_onUpdatePeriodDashboard);
  }

  Future<void> _onDashboardLoadedRequested(
    DashboardLoadRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final dashboard = await DashboardRepositoryImpl(
      DashboardRemoteDataSourceImpl(),
    ).getDashboard();

    emit(DashboardLoaded(data: dashboard.dashboard, date: DateTime.now()));
  }

  Future<void> _onUpdatePeriodDashboard(
    UpdatePeriodDashboard event,
    Emitter<DashboardState> emit,
  ) async {
    emit(
      (state as DashboardLoaded).copyWith(
        message: () => '',
        loading: () => true,
      ),
    );

    final dashboard =
        await DashboardRepositoryImpl(
          DashboardRemoteDataSourceImpl(),
        ).getDashboard(
          days: event.periodKey == DashboardPeriod.week
              ? '7'
              : event.periodKey == DashboardPeriod.month
              ? '30'
              : '90',
        );

    emit(
      (state as DashboardLoaded).copyWith(
        message: () => '',
        loading: () => false,
        data: () => dashboard.dashboard,
        periodKey: () => event.periodKey,
      ),
    );
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<DashboardState> emit,
  ) async {
    emit((state as DashboardLoaded).copyWith(message: () => ''));
  }
}

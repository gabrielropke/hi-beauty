part of 'dashboard_bloc.dart';

enum DashboardTabs { business, appointments, profile }
enum DashboardPeriod { week, month, quarter }

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardDashboard extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String message;
  final bool loading;
  final DashboardModel? data;
  final DashboardPeriod periodKey;
  final DateTime? date;

  const DashboardLoaded({
    this.message = '',
    this.loading = false,
    this.data,
    this.periodKey = DashboardPeriod.week,
    this.date,
  });

  DashboardLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<DashboardModel?>? data,
    ValueGetter<DashboardPeriod>? periodKey,
    ValueGetter<DateTime>? date,
  }) {
    return DashboardLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      data: data != null ? data() : this.data,
      periodKey: periodKey != null ? periodKey() : this.periodKey,
      date: date != null ? date() : this.date,
    );
  }

  @override
  List<Object?> get props => [message, loading, data, periodKey, date];
}

class DashboardEmpty extends DashboardState {}

class DashboardFailure extends DashboardState {}

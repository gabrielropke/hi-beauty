part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLoadRequested extends DashboardEvent {}

class CloseMessage extends DashboardEvent {}

class UpdatePeriodDashboard extends DashboardEvent {
  final DashboardPeriod periodKey;

  const UpdatePeriodDashboard({required this.periodKey});

  @override
  List<Object?> get props => [periodKey];
}
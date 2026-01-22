part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeLoadRequested extends HomeEvent {}

class ChangeTab extends HomeEvent {
  final HomeTabs value;

  const ChangeTab(this.value);

  @override
  List<Object?> get props => [value];
}

class CloseMessage extends HomeEvent {}

class LogoutRequested extends HomeEvent {}

class OpenSchedulesDrawer extends HomeEvent {
  final dynamic schedulesState;
  final BuildContext schedulesContext;

  const OpenSchedulesDrawer({
    required this.schedulesState,
    required this.schedulesContext,
  });

  @override
  List<Object?> get props => [schedulesState, schedulesContext];
}

class CloseSchedulesDrawer extends HomeEvent {}
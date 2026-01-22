part of 'home_bloc.dart';

enum HomeTabs { dashboard, schedules, clients, business }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final String message;
  final bool loading;
  final HomeTabs tab;
  final bool showSchedulesDrawer;
  final dynamic schedulesState;
  final BuildContext? schedulesContext;
  final DateTime? selectedDate;

  const HomeLoaded({
    this.message = '',
    this.loading = false,
    this.tab = HomeTabs.dashboard,
    this.showSchedulesDrawer = false,
    this.schedulesState,
    this.schedulesContext,
    this.selectedDate,
  });

  HomeLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<HomeTabs>? tab,
    ValueGetter<bool>? showSchedulesDrawer,
    ValueGetter<dynamic>? schedulesState,
    ValueGetter<BuildContext?>? schedulesContext,
    ValueGetter<DateTime?>? selectedDate,
  }) {
    return HomeLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      tab: tab != null ? tab() : this.tab,
      showSchedulesDrawer: showSchedulesDrawer != null ? showSchedulesDrawer() : this.showSchedulesDrawer,
      schedulesState: schedulesState != null ? schedulesState() : this.schedulesState,
      schedulesContext: schedulesContext != null ? schedulesContext() : this.schedulesContext,
      selectedDate: selectedDate != null ? selectedDate() : this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [message, loading, tab, showSchedulesDrawer, schedulesState, schedulesContext, selectedDate];
}

class HomeEmpty extends HomeState {}

class HomeFailure extends HomeState {}

part of 'schedules_bloc.dart';

enum TimeLineType { day, threeDays, week, month }

abstract class SchedulesState extends Equatable {
  const SchedulesState();

  @override
  List<Object?> get props => [];
}

class SchedulesInitial extends SchedulesState {}

class SchedulesLoading extends SchedulesState {}

class SchedulesLoaded extends SchedulesState {
  final String message;
  final bool loading;
  final TeamResponseModel team;
  final DateTime date;
  final List<BookingModel>? booking;
  final BookingWeekORMonthModel? bookingWeekOrMonth;
  final TimeLineType timelineType;

  const SchedulesLoaded({
    this.message = '',
    this.loading = false,
    required this.team,
    required this.date,
    this.booking,
    this.bookingWeekOrMonth,
    this.timelineType = TimeLineType.day,
  });

  SchedulesLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<TeamResponseModel>? team,
    ValueGetter<DateTime>? date,
    ValueGetter<List<BookingModel>?>? booking,
    ValueGetter<BookingWeekORMonthModel?>? bookingWeekOrMonth,
    ValueGetter<TimeLineType>? timelineType,
  }) {
    return SchedulesLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      team: team != null ? team() : this.team,
      date: date != null ? date() : this.date,
      booking: booking != null ? booking() : this.booking,
      bookingWeekOrMonth: bookingWeekOrMonth != null
          ? bookingWeekOrMonth()
          : this.bookingWeekOrMonth,
      timelineType: timelineType != null ? timelineType() : this.timelineType,
    );
  }

  @override
  List<Object?> get props => [
    message,
    loading,
    team,
    date,
    booking,
    bookingWeekOrMonth,
    timelineType,
  ];
}

class SchedulesEmpty extends SchedulesState {}

class SchedulesFailure extends SchedulesState {}

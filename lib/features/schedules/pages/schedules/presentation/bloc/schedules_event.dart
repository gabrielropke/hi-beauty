part of 'schedules_bloc.dart';

abstract class SchedulesEvent extends Equatable {
  const SchedulesEvent();

  @override
  List<Object?> get props => [];
}

class SchedulesLoadRequested extends SchedulesEvent {}

class CloseMessage extends SchedulesEvent {}

class SelectDate extends SchedulesEvent {
  final DateTime date;

  const SelectDate({required this.date});

  @override
  List<Object?> get props => [date];
}

class SelectTimelineType extends SchedulesEvent {
  final TimeLineType timelineType;
  final DateTime? date;

  const SelectTimelineType({required this.timelineType, this.date});

  @override
  List<Object?> get props => [timelineType, date];
}
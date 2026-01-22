part of 'business_hours_bloc.dart';

abstract class BusinessHoursEvent extends Equatable {
  const BusinessHoursEvent();

  @override
  List<Object?> get props => [];
}

class BusinessHoursLoadRequested extends BusinessHoursEvent {}

class CloseMessage extends BusinessHoursEvent {}

class BusinessHoursSave extends BusinessHoursEvent {
  final List<OpeningHour> body;

  const BusinessHoursSave(this.body);

  @override
  List<Object?> get props => [body];
}

class SetLocalUpdateHours extends BusinessHoursEvent {
  final List<OpeningHour> updatedHours;

  const SetLocalUpdateHours(this.updatedHours);

  @override
  List<Object?> get props => [updatedHours];
}

class UpdateTeamMember extends BusinessHoursEvent {
  final String id;
  final CreateTeamModel body;

  const UpdateTeamMember(this.id, this.body);

  @override
  List<Object?> get props => [id, body];
}
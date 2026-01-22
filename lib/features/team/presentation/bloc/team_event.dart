part of 'team_bloc.dart';

abstract class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object?> get props => [];
}

class TeamLoadRequested extends TeamEvent {}

class CloseMessage extends TeamEvent {}

class CreateTeamMember extends TeamEvent {
  final CreateTeamModel body;

  const CreateTeamMember(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateTeamMember extends TeamEvent {
  final String id;
  final CreateTeamModel body;

  const UpdateTeamMember(this.id, this.body);

  @override
  List<Object?> get props => [id, body];
}

class DeleteTeamMember extends TeamEvent {
  final String id;

  const DeleteTeamMember(this.id);

  @override
  List<Object?> get props => [id];
}
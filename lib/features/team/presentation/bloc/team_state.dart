part of 'team_bloc.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object?> get props => [];
}

class TeamTeam extends TeamState {}

class TeamLoading extends TeamState {}

class TeamLoaded extends TeamState {
  final String message;
  final bool loading;
  final TeamResponseModel team;

  const TeamLoaded({
    this.message = '',
    this.loading = false,
    required this.team,
  });

  TeamLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<TeamResponseModel>? team,
  }) {
    return TeamLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      team: team != null ? team() : this.team,
    );
  }

  @override
  List<Object?> get props => [message, loading, team];
}

class TeamEmpty extends TeamState {}

class TeamFailure extends TeamState {}

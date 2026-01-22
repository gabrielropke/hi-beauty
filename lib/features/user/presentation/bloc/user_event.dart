part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserLoadRequested extends UserEvent {}

class SetMessage extends UserEvent {
  final Map<String, String> message;

  const SetMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class CloseMessage extends UserEvent {}
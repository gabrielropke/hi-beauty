part of 'functions_bloc.dart';

abstract class FunctionsEvent extends Equatable {
  const FunctionsEvent();

  @override
  List<Object?> get props => [];
}

class FunctionsLoadRequested extends FunctionsEvent {}

class SetMessage extends FunctionsEvent {
  final Map<String, String> message;

  const SetMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class CloseMessage extends FunctionsEvent {}
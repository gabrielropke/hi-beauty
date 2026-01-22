part of 'signature_bloc.dart';

abstract class SignatureEvent extends Equatable {
  const SignatureEvent();

  @override
  List<Object?> get props => [];
}

class SignatureLoadRequested extends SignatureEvent {}

class SetMessage extends SignatureEvent {
  final Map<String, String> message;

  const SetMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class CloseMessage extends SignatureEvent {}

class CreateCheckout extends SignatureEvent {}

class CancelSignature extends SignatureEvent {}

class ReactivateSignature extends SignatureEvent {}
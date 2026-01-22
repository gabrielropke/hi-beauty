part of 'signature_bloc.dart';

abstract class SignatureState extends Equatable {
  const SignatureState();

  @override
  List<Object?> get props => [];
}

class SignatureInitial extends SignatureState {}

class SignatureLoading extends SignatureState {}

class SignatureLoaded extends SignatureState {
  final Map<String, String> message;
  final bool loading;
  final TeamResponseModel team;
  final MySubscriptionModel? subscription;

  const SignatureLoaded({
    this.message = const {'': ''},
    this.loading = false,
    required this.team,
    this.subscription,
  });

  SignatureLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
    ValueGetter<TeamResponseModel>? team,
    ValueGetter<MySubscriptionModel?>? subscription,
  }) {
    return SignatureLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      team: team != null ? team() : this.team,
      subscription: subscription != null ? subscription() : this.subscription,
    );
  }

  @override
  List<Object?> get props => [
    message,
    loading,
    team,
    subscription,
  ];
}

class SignatureEmpty extends SignatureState {}

class SignatureFailure extends SignatureState {}

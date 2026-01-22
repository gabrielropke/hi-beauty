part of 'functions_bloc.dart';

abstract class FunctionsState extends Equatable {
  const FunctionsState();

  @override
  List<Object?> get props => [];
}

class FunctionsInitial extends FunctionsState {}

class FunctionsLoading extends FunctionsState {}

class FunctionsLoaded extends FunctionsState {
  final Map<String, String> message;
  final bool loading;

  const FunctionsLoaded({
    this.message = const {'': ''},
    this.loading = false,
  });

  FunctionsLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
  }) {
    return FunctionsLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
    );
  }

  @override
  List<Object?> get props => [
    message,
    loading,
  ];
}

class FunctionsEmpty extends FunctionsState {}

class FunctionsFailure extends FunctionsState {}

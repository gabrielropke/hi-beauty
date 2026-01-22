part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Map<String, String> message;
  final bool loading;

  const UserLoaded({
    this.message = const {'': ''},
    this.loading = false,
  });

  UserLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
  }) {
    return UserLoaded(
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

class UserEmpty extends UserState {}

class UserFailure extends UserState {}

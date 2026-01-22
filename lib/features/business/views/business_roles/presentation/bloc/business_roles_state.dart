part of 'business_roles_bloc.dart';

abstract class BusinessRolesState extends Equatable {
  const BusinessRolesState();

  @override
  List<Object?> get props => [];
}

class BusinessRolesBusinessRoles extends BusinessRolesState {}

class BusinessRolesLoading extends BusinessRolesState {}

class BusinessRolesLoaded extends BusinessRolesState {
  final String message;
  final bool loading;
  final BusinessRulesResponseModel roles;

  const BusinessRolesLoaded({
    this.message = '',
    this.loading = false,
    required this.roles,
  });

  BusinessRolesLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<BusinessRulesResponseModel>? roles,
  }) {
    return BusinessRolesLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      roles: roles != null ? roles() : this.roles,
    );
  }

  @override
  List<Object?> get props => [message, loading, roles];
}

class BusinessRolesEmpty extends BusinessRolesState {}

class BusinessRolesFailure extends BusinessRolesState {}

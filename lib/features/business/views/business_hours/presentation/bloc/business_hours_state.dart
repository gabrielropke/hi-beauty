part of 'business_hours_bloc.dart';

abstract class BusinessHoursState extends Equatable {
  const BusinessHoursState();

  @override
  List<Object?> get props => [];
}

class BusinessHoursBusinessHours extends BusinessHoursState {}

class BusinessHoursLoading extends BusinessHoursState {}

class BusinessHoursLoaded extends BusinessHoursState {
  final String message;
  final bool loading;
  final List<TeamMemberModel> teamMembers;
  final List<OpeningHour> openingHours;

  const BusinessHoursLoaded({
    this.message = '',
    this.loading = false,
    this.teamMembers = const [],
    this.openingHours = const [],
  });

  BusinessHoursLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<List<TeamMemberModel>>? teamMembers,
    ValueGetter<List<OpeningHour>>? openingHours,
  }) {
    return BusinessHoursLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      teamMembers: teamMembers != null ? teamMembers() : this.teamMembers,
      openingHours: openingHours != null ? openingHours() : this.openingHours,
    );
  }

  @override
  List<Object?> get props => [message, loading, teamMembers, openingHours];
}

class BusinessHoursEmpty extends BusinessHoursState {}

class BusinessHoursFailure extends BusinessHoursState {}

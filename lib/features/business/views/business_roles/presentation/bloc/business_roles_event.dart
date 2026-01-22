part of 'business_roles_bloc.dart';

abstract class BusinessRolesEvent extends Equatable {
  const BusinessRolesEvent();

  @override
  List<Object?> get props => [];
}

class BusinessRolesLoadRequested extends BusinessRolesEvent {}

class BusinessRulesSaveRequested extends BusinessRolesEvent {
  final BusinessRulesModel businessRules;
  
  const BusinessRulesSaveRequested({required this.businessRules});
  
  @override
  List<Object?> get props => [businessRules];
}

class CloseMessage extends BusinessRolesEvent {}
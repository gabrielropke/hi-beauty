part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingLoadRequested extends OnboardingEvent {}

class SetMessage extends OnboardingEvent {
  final Map<String, String> message;

  const SetMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class CloseMessage extends OnboardingEvent {}

class AdvanceStep extends OnboardingEvent {
  final Steps? to;

  const AdvanceStep({this.to});

  @override
  List<Object?> get props => [to];
}

class SelectSubSegment extends OnboardingEvent {
  final String subSegmentKey;
  const SelectSubSegment(this.subSegmentKey);
  @override
  List<Object?> get props => [subSegmentKey];
}

class SelectTeamSize extends OnboardingEvent {
  final String teamSizeKey;
  const SelectTeamSize(this.teamSizeKey);
  @override
  List<Object?> get props => [teamSizeKey];
}

class SelectMainObjective extends OnboardingEvent {
  final String mainObjectiveKey;
  const SelectMainObjective(this.mainObjectiveKey);
  @override
  List<Object?> get props => [mainObjectiveKey];
}

class BackStep extends OnboardingEvent {
  const BackStep();
}

class CreateSetupBasic extends OnboardingEvent {
  final SetupBasicModel body;

  const CreateSetupBasic(this.body);

  @override
  List<Object?> get props => [body];
}

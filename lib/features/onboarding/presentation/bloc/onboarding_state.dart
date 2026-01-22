part of 'onboarding_bloc.dart';

enum Steps { nameAndSlug, subsegments, teamSize, mainObjective }

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final Map<String, String> message;
  final bool loading;
  final List<SubSegmentsModel> subsegments;
  final List<MainObjectiveModel> mainObjectives;
  final List<TeamSizeModel> teamSize;
  final Steps step;
  final List<String>? selectedSubSegmentKey;
  final String? selectedTeamSizeKey;
  final String? selectedMainObjectiveKey;

  const OnboardingLoaded({
    this.message = const {'': ''},
    this.loading = false,
    this.subsegments = const [],
    this.mainObjectives = const [],
    this.teamSize = const [],
    this.step = Steps.nameAndSlug,
    this.selectedSubSegmentKey,
    this.selectedTeamSizeKey,
    this.selectedMainObjectiveKey,
  });

  OnboardingLoaded copyWith({
    ValueGetter<Map<String, String>>? message,
    ValueGetter<bool>? loading,
    ValueGetter<List<SubSegmentsModel>>? subsegments,
    ValueGetter<List<MainObjectiveModel>>? mainObjectives,
    ValueGetter<List<TeamSizeModel>>? teamSize,
    ValueGetter<Steps>? step,
    ValueGetter<List<String>?>? selectedSubSegmentKey,
    ValueGetter<String?>? selectedTeamSizeKey,
    ValueGetter<String?>? selectedMainObjectiveKey,
  }) {
    return OnboardingLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      subsegments: subsegments != null ? subsegments() : this.subsegments,
      mainObjectives: mainObjectives != null
          ? mainObjectives()
          : this.mainObjectives,
      teamSize: teamSize != null ? teamSize() : this.teamSize,
      step: step != null ? step() : this.step,
      selectedSubSegmentKey: selectedSubSegmentKey != null
          ? selectedSubSegmentKey()
          : this.selectedSubSegmentKey,
      selectedTeamSizeKey: selectedTeamSizeKey != null
          ? selectedTeamSizeKey()
          : this.selectedTeamSizeKey,
      selectedMainObjectiveKey: selectedMainObjectiveKey != null
          ? selectedMainObjectiveKey()
          : this.selectedMainObjectiveKey
    );
  }

  @override
  List<Object?> get props => [
    message,
    loading,
    subsegments,
    mainObjectives,
    teamSize,
    step,
    selectedSubSegmentKey,
    selectedTeamSizeKey,
    selectedMainObjectiveKey,
  ];
}

class OnboardingEmpty extends OnboardingState {}

class OnboardingFailure extends OnboardingState {}

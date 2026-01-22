import 'package:hibeauty/core/services/business_options/data/model.dart';

abstract class BusinessOptionsRepository {
  Future<List<SegmentsModel>> getSegments();
  Future<List<SubSegmentsModel>> getSubSegments();
  Future<List<TeamSizeModel>> getTeamSize();
  Future<List<MainObjectiveModel>> getMainObjectives();
}

class GetTeamSize {
  final BusinessOptionsRepository repository;
  GetTeamSize(this.repository);

  Future<List<TeamSizeModel>> call() {
    return repository.getTeamSize();
  }
}

class GetMainObjectives {
  final BusinessOptionsRepository repository;
  GetMainObjectives(this.repository);

  Future<List<MainObjectiveModel>> call() {
    return repository.getMainObjectives();
  }
}

class GetSegments {
  final BusinessOptionsRepository repository;
  GetSegments(this.repository);

  Future<List<SegmentsModel>> call() {
    return repository.getSegments();
  }
}

class GetSubSegments {
  final BusinessOptionsRepository repository;
  GetSubSegments(this.repository);

  Future<List<SubSegmentsModel>> call() {
    return repository.getSubSegments();
  }
}

  
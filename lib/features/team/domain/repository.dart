import '../data/model.dart';

abstract class TeamRepository {
  Future<TeamResponseModel> getTeam({
    String? search,
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  });
  Future<void> createTeamMember(CreateTeamModel model);
  Future<void> deleteTeamMember(String id);
}

class DeleteTeamMember {
  final TeamRepository repository;
  DeleteTeamMember(this.repository);

  Future<void> call(String id) {
    return repository.deleteTeamMember(id);
  }
}

class GetTeam {
  final TeamRepository repository;
  GetTeam(this.repository);

  Future<TeamResponseModel> call({
    String? search,
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.getTeam(
      search: search,
      status: status,
      role: role,
      page: page,
      pageSize: pageSize,
    );
  }
}

class CreateTeamMember {
  final TeamRepository repository;
  CreateTeamMember(this.repository);

  Future<void> call(CreateTeamModel model) {
    return repository.createTeamMember(model);
  }
}

import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remote;

  TeamRepositoryImpl(this.remote);

  @override
  Future<void> deleteTeamMember(String id) async {
    try {
      await remote.deleteTeamMember(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<TeamResponseModel> getTeam({
    String? search,
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await remote.getTeam(
        search: search,
        status: status,
        role: role,
        page: page,
        pageSize: pageSize,
      );
      return response;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createTeamMember(CreateTeamModel model) async {
    try {
      await remote.createTeamMember(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

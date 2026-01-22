import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/core/services/business_options/domain/repository.dart';
import 'model.dart';
import 'data_source.dart';

class BusinessOptionsRepositoryImpl implements BusinessOptionsRepository {
  final BusinessOptionsRemoteDataSource remote;
  BusinessOptionsRepositoryImpl(this.remote);

  @override
  Future<List<TeamSizeModel>> getTeamSize() async {
    try {
      final list = await remote.getTeamSize();
      return list;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<MainObjectiveModel>> getMainObjectives() async {
    try {
      final list = await remote.getMainObjectives();
      return list;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<SegmentsModel>> getSegments() async {
    try {
      final list = await remote.getSegments();
      return list;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<SubSegmentsModel>> getSubSegments() async {
    try {
      final list = await remote.getSubSegments();
      return list;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

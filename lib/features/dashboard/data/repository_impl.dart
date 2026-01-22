import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl(this.remote);

  @override
  Future<DashboardResponseModel> getDashboard({String? days}) async {
    try {
      return await remote.getDashboard(days: days);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

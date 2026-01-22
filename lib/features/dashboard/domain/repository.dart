import '../data/model.dart';

abstract class DashboardRepository {
  Future<DashboardResponseModel> getDashboard({String? days});
}

class GetDashboard {
  final DashboardRepository repository;
  GetDashboard(this.repository);

  Future<void> call({String? days}) {
    return repository.getDashboard(days: days);
  }
}

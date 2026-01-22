import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/features/onboarding/data/setup/model.dart';
import 'package:hibeauty/features/onboarding/domain/setup/repository.dart';
import 'data_source.dart';

class SetupBusinessRepositoryImpl implements SetupBusinessRepository {
  final SetupBusinessRemoteDataSource remote;
  SetupBusinessRepositoryImpl(this.remote);

  @override
  Future<void> createSetupBasic(SetupBasicModel body) async {
    try {
      return await remote.createSetupBasic(body);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

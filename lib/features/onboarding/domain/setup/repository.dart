import 'package:hibeauty/features/onboarding/data/setup/model.dart';

abstract class SetupBusinessRepository {
  Future<void> createSetupBasic(SetupBasicModel body);
}

class SetupBusiness {
  final SetupBusinessRepository repository;
  SetupBusiness(this.repository);

  Future<void> call(SetupBasicModel body) {
    return repository.createSetupBasic(body);
  }
}

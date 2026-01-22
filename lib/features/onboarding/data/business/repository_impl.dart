import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';
import '../../domain/business/repository.dart';
import 'data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remote;
  OnboardingRepositoryImpl(this.remote);

  @override
  Future<BusinessModel> getBusiness() async {
    try {
      return await remote.getBusiness();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

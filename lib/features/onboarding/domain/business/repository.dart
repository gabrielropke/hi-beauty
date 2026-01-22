abstract class OnboardingRepository {
  Future<void> getBusiness();
}

class GetBusiness {
  final OnboardingRepository repository;
  GetBusiness(this.repository);

  Future<void> call() {
    return repository.getBusiness();
  }
}

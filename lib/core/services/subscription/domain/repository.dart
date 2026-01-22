import 'package:hibeauty/core/services/subscription/data/model.dart';

abstract class SubscriptionRepository {
  Future<MySubscriptionModel> getMySubscription();
  Future<SubscriptionStatusModel> getSubscriptionStatus();
  Future<CreateResponse> createCheckoutSession();
  Future<void> deleteSubscription();
  Future<void> reactivateSubscription();
}

class GetSubscriptionStatus {
  final SubscriptionRepository repository;
  GetSubscriptionStatus(this.repository);

  Future<SubscriptionStatusModel> call() {
    return repository.getSubscriptionStatus();
  }
}

class CreateCheckoutSession {
  final SubscriptionRepository repository;
  CreateCheckoutSession(this.repository);

  Future<CreateResponse> call() {
    return repository.createCheckoutSession();
  }
}

class GetMySubscription {
  final SubscriptionRepository repository;
  GetMySubscription(this.repository);

  Future<MySubscriptionModel> call() {
    return repository.getMySubscription();
  }
}

class DeleteSubscription {
  final SubscriptionRepository repository;
  DeleteSubscription(this.repository);

  Future<void> call() {
    return repository.deleteSubscription();
  }
}

class ReactivateSubscription {
  final SubscriptionRepository repository;
  ReactivateSubscription(this.repository);

  Future<void> call() {
    return repository.reactivateSubscription();
  }
}
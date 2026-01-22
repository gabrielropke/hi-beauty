import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/core/services/subscription/domain/repository.dart';
import 'model.dart';
import 'data_source.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remote;
  SubscriptionRepositoryImpl(this.remote);

  @override
  Future<SubscriptionStatusModel> getSubscriptionStatus() async {
    try {
      final list = await remote.getSubscriptionStatus();
      return list;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CreateResponse> createCheckoutSession() async {
    try {
      return await remote.createCheckoutSession();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<MySubscriptionModel> getMySubscription() async {
    try {
      return await remote.getMySubscription();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteSubscription() async {
    try {
      return await remote.deleteSubscription();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> reactivateSubscription() async {
    try {
      return await remote.reactivateSubscription();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

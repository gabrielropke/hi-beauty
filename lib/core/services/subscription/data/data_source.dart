import 'dart:convert';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<MySubscriptionModel> getMySubscription();
  Future<SubscriptionStatusModel> getSubscriptionStatus();
  Future<CreateResponse> createCheckoutSession();
  Future<void> deleteSubscription();
  Future<void> reactivateSubscription();
}

class SubscriptionRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SubscriptionRemoteDataSource {
  SubscriptionRemoteDataSourceImpl({super.client, super.rawUrl, super.timeout});

  @override
  Future<MySubscriptionModel> getMySubscription() async {
    final uri = buildUri('v1/hi-subscription/details');

    final res = await getJson(
      uri,
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return MySubscriptionModel.fromMap(data);
    }

    final apiFailure = ApiFailure.fromResponse(res);
    throw apiFailure;
  }

  @override
  Future<SubscriptionStatusModel> getSubscriptionStatus() async {
    final uri = buildUri('v1/hi-subscription/status');

    final res = await getJson(
      uri,
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return SubscriptionStatusModel.fromMap(data);
    }

    final apiFailure = ApiFailure.fromResponse(res);
    throw apiFailure;
  }

  @override
  Future<CreateResponse> createCheckoutSession() async {
    final uri = buildUri('v1/hi-subscription/create-checkout-session');

    final Map<String, dynamic> brandMap = await BrandLoader.load();
    final String domain = brandMap['domain'];

    final res = await postJson(
      uri,
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
      body: {
        "customerEmail": UserData.email,
        "successUrl": "https://$domain/checkout/success",
        "cancelUrl": "https://$domain/checkout/cancel",
      },
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final Map<String, dynamic> data = jsonDecode(res.body);
      return CreateResponse.fromMap(data);
    }

    final apiFailure = ApiFailure.fromResponse(res);
    throw apiFailure;
  }

  @override
  Future<void> deleteSubscription() async {
    final uri = buildUri('v1/hi-subscription/my-subscription');

    final res = await deleteJson(
      uri,
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
      body: {},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    }

    final apiFailure = ApiFailure.fromResponse(res);
    throw apiFailure;
  }

  @override
  Future<void> reactivateSubscription() async {
    final uri = buildUri('v1/hi-subscription/my-subscription/reactivate');

    final res = await postJson(
      uri,
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
        'accept': 'application/json',
      },
      body: {},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return;
    }

    final apiFailure = ApiFailure.fromResponse(res);
    throw apiFailure;
  }
}

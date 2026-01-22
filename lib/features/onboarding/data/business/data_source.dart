import 'dart:convert';

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/data/secure_storage.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart';

abstract class OnboardingRemoteDataSource {
  Future<BusinessModel> getBusiness();
}

class OnboardingRemoteDataSourceImpl extends BaseRemoteDataSource
    implements OnboardingRemoteDataSource {
  OnboardingRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<BusinessModel> getBusiness() async {
    
    final uri = buildUri('v1/business/my-business');
    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final responseData = json.decode(res.body) as Map<String, dynamic>;
    
    final businessData = responseData['business'] as Map<String, dynamic>;

    final business = BusinessModel.fromJson(businessData);
    
    BusinessService().setBusiness(business);
    await SecureStorage.saveBusiness(business);

    return BusinessModel.fromJson(responseData);
  }
}

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/features/onboarding/data/setup/model.dart';

abstract class SetupBusinessRemoteDataSource {
  Future<void> createSetupBasic(SetupBasicModel body);
}

class SetupBusinessRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SetupBusinessRemoteDataSource {
  SetupBusinessRemoteDataSourceImpl({
    super.client,
    super.baseUrl,
    super.timeout,
  });

  @override
  Future<void> createSetupBasic(SetupBasicModel body) async {
    final uri = buildUri('v1/business/setup/basic');
    final res = await postJson(
      uri,
      body: body.toJson(),
      headers: {
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);

    if (!apiFailure.ok) throw apiFailure;

    return;
  }
}

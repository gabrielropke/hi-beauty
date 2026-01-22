import 'dart:convert';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardResponseModel> getDashboard({String? days});
}

class DashboardRemoteDataSourceImpl extends BaseRemoteDataSource
    implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<DashboardResponseModel> getDashboard({String? days}) async {
    final uri = buildUri('v1/dashboard', {'period': days ?? '7'});

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

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return DashboardResponseModel.fromJson(decoded);
  }
}

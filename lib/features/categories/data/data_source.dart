import 'dart:convert';

import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

abstract class CategorieRemoteDataSource {
  Future<void> createServiceCategorie(CreateCategorieModel model);
  Future<void> createProductCategorie(CreateCategorieModel model);
  Future<CategoriesProductsResponseModel> getProductCategories();
}

class CategorieRemoteDataSourceImpl extends BaseRemoteDataSource
    implements CategorieRemoteDataSource {
  CategorieRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<void> createServiceCategorie(CreateCategorieModel model) async {
    final uri = buildUri('v1/services/categories');

    final res = await postJson(
      uri,
      body: model.toJson(),
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> createProductCategorie(CreateCategorieModel model) async {
    final uri = buildUri('v1/products/categories');

    final res = await postJson(
      uri,
      body: model.toJson(),
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<CategoriesProductsResponseModel> getProductCategories() async {
    final uri = buildUri('v1/products/categories');

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) {
      throw apiFailure;
    }

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    return CategoriesProductsResponseModel.fromJson(decoded);
  }

}

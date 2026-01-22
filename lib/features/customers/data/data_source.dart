import 'dart:convert';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

abstract class CustomersRemoteDataSource {
  Future<CustomersResponseModel> getCustomers({
    String? search,
    String? status,
    String? role,
    int page,
    int pageSize,
  });
  Future<CustomerWithBookingsModel> getCustomerById({
    required String id,
    int page = 1,
    int limit = 10,
  });
  Future<void> createCustomer(CreateCustomerModel model);
  Future<void> updateCustomer(String id, CreateCustomerModel model);
  Future<void> deleteCustomerMember(String id);
}

class CustomersRemoteDataSourceImpl extends BaseRemoteDataSource
  implements CustomersRemoteDataSource {
  CustomersRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  @override
  Future<CustomersResponseModel> getCustomers({
  String? search,
  String? status,
  String? role,
  int page = 1,
  int pageSize = 20,
  }) async {
  final queryParams = {
    if (search != null && search.isNotEmpty) 'search': search,
    if (status != null && status.isNotEmpty) 'status': status,
    if (role != null && role.isNotEmpty) 'role': role,
    'page': '$page',
    'pageSize': '$pageSize',
  };

  final uri = buildUri('v1/customers', queryParams);

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

  return CustomersResponseModel.fromJson(decoded);
  }

  @override
  Future<CustomerWithBookingsModel> getCustomerById({
  required String id,
  int page = 1,
  int limit = 10,
  }) async {
  final queryParams = {
    'page': '$page',
    'limit': '$limit',
  };

  final uri = buildUri('v1/customers/$id', queryParams);

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

  return CustomerWithBookingsModel.fromJson(decoded);
  }

  @override
  Future<void> deleteCustomerMember(String id) async {
  final uri = buildUri('v1/customers/$id');

  final res = await deleteJson(
    uri,
    headers: {
    'accept': 'application/json',
    'X-Brand-Id': await BrandLoader.getBrandHeader(),
    'Authorization': 'Bearer ${UserData.userSessionToken}',
    },
    body: {},
  );

  final apiFailure = ApiFailure.fromResponse(res);
  if (!apiFailure.ok) {
    throw apiFailure;
  }
  }

  @override
  Future<void> updateCustomer(String id, CreateCustomerModel model) async {
  final uri = buildUri('v1/customers/$id');

  final body = {
    'name': model.name,
    'phone': model.phone,
    'email': model.email,
    if (model.birthDate != null) 'birthDate': model.birthDate!.toIso8601String().split('T').first,
    if (model.notes != null) 'notes': model.notes,
  };

  final res = await patchJson(
    uri,
    headers: {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Brand-Id': await BrandLoader.getBrandHeader(),
    'Authorization': 'Bearer ${UserData.userSessionToken}',
    },
    body: body,
  );

  final apiFailure = ApiFailure.fromResponse(res);
  if (!apiFailure.ok) {
    throw apiFailure;
  }
  }

  @override
  Future<void> createCustomer(CreateCustomerModel model) async {
  final uri = buildUri('v1/customers');

  final body = {
    'name': model.name,
    'phone': model.phone,
    'email': model.email,
    if (model.birthDate != null) 'birthDate': model.birthDate!.toIso8601String().split('T').first,
    if (model.notes != null) 'notes': model.notes,
  };

  final res = await postJson(
    uri,
    headers: {
    'accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Brand-Id': await BrandLoader.getBrandHeader(),
    'Authorization': 'Bearer ${UserData.userSessionToken}',
    },
    body: body,
  );

  final apiFailure = ApiFailure.fromResponse(res);
  if (!apiFailure.ok) {
    throw apiFailure;
  }
  }
}

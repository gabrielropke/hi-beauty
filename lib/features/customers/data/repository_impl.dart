import 'package:hibeauty/core/constants/failures.dart';
import '../domain/repository.dart';
import 'data_source.dart';
import 'model.dart';

class CustomersRepositoryImpl implements CustomersRepository {
  final CustomersRemoteDataSource remote;

  CustomersRepositoryImpl(this.remote);

  @override
  Future<void> deleteCustomersMember(String id) async {
    try {
      await remote.deleteCustomerMember(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createCustomer(CreateCustomerModel model) async {
    try {
      await remote.createCustomer(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateCustomer(String id, CreateCustomerModel model) async {
    try {
      await remote.updateCustomer(id, model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CustomersResponseModel> getCustomers({
    String? search,
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await remote.getCustomers(
        search: search,
        status: status,
        role: role,
        page: page,
        pageSize: pageSize,
      );
      return response;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<CustomerWithBookingsModel> getCustomerById({
    required String id,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remote.getCustomerById(
        id: id,
        page: page,
        limit: limit,
      );
      return response;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  // @override
  // Future<void> createCustomersMember(CreateCustomersModel model) async {
  //   try {
  //     await remote.createCustomersMember(model);
  //   } catch (e) {
  //     throw ServerFailure(e.toString());
  //   }
  // }
}

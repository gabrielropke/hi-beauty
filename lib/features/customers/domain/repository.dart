import '../data/model.dart';

abstract class CustomersRepository {
  Future<CustomersResponseModel> getCustomers({
    String? search,
    String? status,
    String? role,
    int page = 1,
    int pageSize = 20,
  });
  Future<CustomerWithBookingsModel> getCustomerById({
    required String id,
    int page = 1,
    int limit = 10,
  });
  Future<void> createCustomer(CreateCustomerModel model);
  Future<void> updateCustomer(String id, CreateCustomerModel model);
  Future<void> deleteCustomersMember(String id);
}

class DeleteCustomersMember {
  final CustomersRepository repository;
  DeleteCustomersMember(this.repository);

  Future<void> call(String id) {
    return repository.deleteCustomersMember(id);
  }
}

// class GetCustomers {
//   final CustomersRepository repository;
//   GetCustomers(this.repository);

//   Future<CustomersResponseModel> call({
//     String? search,
//     String? status,
//     String? role,
//     int page = 1,
//     int pageSize = 20,
//   }) {
//     return repository.getCustomers(
//       search: search,
//       status: status,
//       role: role,
//       page: page,
//       pageSize: pageSize,
//     );
//   }
// }

// class CreateCustomersMember {
//   final CustomersRepository repository;
//   CreateCustomersMember(this.repository);

//   Future<void> call(CreateCustomersModel model) {
//     return repository.createCustomersMember(model);
//   }
// }

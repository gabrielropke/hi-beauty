part of 'customers_bloc.dart';

abstract class CustomersEvent extends Equatable {
  const CustomersEvent();

  @override
  List<Object?> get props => [];
}

class CustomersLoadRequested extends CustomersEvent {}

class CloseMessage extends CustomersEvent {}

class CreateCustomers extends CustomersEvent {
  final CreateCustomerModel body;

  const CreateCustomers(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateCustomers extends CustomersEvent {
  final String id;
  final CreateCustomerModel body;

  const UpdateCustomers(this.id, this.body);

  @override
  List<Object?> get props => [id, body];
}

class DeleteCustomers extends CustomersEvent {
  final String id;

  const DeleteCustomers(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadCustomerWithBookings extends CustomersEvent {
  final String customerId;
  final int page;
  final int limit;

  const LoadCustomerWithBookings({
    required this.customerId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [customerId, page, limit];
}
part of 'customers_bloc.dart';

abstract class CustomersState extends Equatable {
  const CustomersState();

  @override
  List<Object?> get props => [];
}

class CustomersInitial extends CustomersState {}

class CustomersLoading extends CustomersState {}

class CustomersLoaded extends CustomersState {
  final String message;
  final bool loading;
  final CustomersResponseModel customers;
  final CustomerWithBookingsModel? customerWithBookings;

  const CustomersLoaded({
    this.message = '',
    this.loading = false,
    required this.customers,
    this.customerWithBookings,
  });

  CustomersLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<CustomersResponseModel>? customers,
    ValueGetter<CustomerWithBookingsModel?>? customerWithBookings,
  }) {
    return CustomersLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      customers: customers != null ? customers() : this.customers,
      customerWithBookings: customerWithBookings != null ? customerWithBookings() : this.customerWithBookings,
    );
  }

  @override
  List<Object?> get props => [message, loading, customers, customerWithBookings];
}

class CustomersEmpty extends CustomersState {}

class CustomersFailure extends CustomersState {}

import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/features/customers/data/data_source.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/customers/domain/repository.dart';
import 'package:hibeauty/features/customers/data/repository_impl.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  final BuildContext context;
  final CustomersRepository repository;

  CustomersBloc(this.context)
    : repository = CustomersRepositoryImpl(CustomersRemoteDataSourceImpl()),
      super(CustomersInitial()) {
    on<CustomersLoadRequested>(_onCustomersLoadedRequested);
    on<LoadCustomerWithBookings>(_onLoadCustomerWithBookings);
    on<CloseMessage>(_onCloseMessage);
    on<CreateCustomers>(_onCreateCustomers);
    on<DeleteCustomers>(_onDeleteCustomers);
    on<UpdateCustomers>(_onUpdateCustomers);
  }

  Future<void> _onCustomersLoadedRequested(
    CustomersLoadRequested event,
    Emitter<CustomersState> emit,
  ) async {
    final customers = await repository.getCustomers();
    emit(CustomersLoaded(customers: customers));
  }

  Future<void> _onLoadCustomerWithBookings(
    LoadCustomerWithBookings event,
    Emitter<CustomersState> emit,
  ) async {
    if (state is! CustomersLoaded) return;

    try {
      emit((state as CustomersLoaded).copyWith(loading: () => true));

      final customerWithBookings = await repository.getCustomerById(
        id: event.customerId,
        page: event.page,
        limit: event.limit,
      );

      emit(
        (state as CustomersLoaded).copyWith(
          loading: () => false,
          customerWithBookings: () => customerWithBookings,
        ),
      );
    } catch (e) {
      developer.log(
        'Error loading customer with bookings: $e',
        name: 'CustomersBloc',
      );
      emit((state as CustomersLoaded).copyWith(loading: () => false));
      if (e is ApiFailure) {
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
      }
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<CustomersState> emit,
  ) async {
    emit((state as CustomersLoaded).copyWith(message: () => ''));
  }

  Future<void> _onDeleteCustomers(
    DeleteCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(
      (state as CustomersLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await repository.deleteCustomersMember(event.id);
      final customers = await repository.getCustomers();

      developer.log('Customer deleted successfully', name: 'Customers');

      AppFloatingMessage.show(
        context,
        message: 'Cliente excluído com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as CustomersLoaded).copyWith(
          loading: () => false,
          message: () => '',
          customers: () => customers,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        emit(
          (state as CustomersLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onUpdateCustomers(
    UpdateCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(
      (state as CustomersLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await repository.updateCustomer(event.id, event.body);
      final customers = await repository.getCustomers();

      developer.log('Customer updated successfully', name: 'Customers');

      AppFloatingMessage.show(
        context,
        message: 'Cliente atualizado com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as CustomersLoaded).copyWith(
          loading: () => false,
          message: () => '',
          customers: () => customers,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        emit(
          (state as CustomersLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onCreateCustomers(
    CreateCustomers event,
    Emitter<CustomersState> emit,
  ) async {
    emit(
      (state as CustomersLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await repository.createCustomer(event.body);
      final customers = await repository.getCustomers();

      developer.log('Customer created with successfuly', name: 'Customers');

      AppFloatingMessage.show(
        context,
        message: 'Cliente criado com sucesso',
        type: AppFloatingMessageType.success,
      );
      emit(
        (state as CustomersLoaded).copyWith(
          loading: () => false,
          message: () => '',
          customers: () => customers,
        ),
      );
      context.pop();
    } catch (e) {
      if (e is ApiFailure) {
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        emit(
          (state as CustomersLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
      emit(
        (state as CustomersLoaded).copyWith(
          loading: () => false,
          message: () => 'Algo deu errado ao criar o cliente',
        ),
      );
    }
  }
}

// ignore_for_file: constant_identifier_names

part of 'add_schedule_bloc.dart';

enum PaymentMethods { CASH, CARD, PIX, OTHER }
enum TransactionStatus { PENDING, COMPLETED, PAID, CANCELLED, OVERDUE, REFUNDED }
enum Recurrencetypes { none, daily, weekdays, weekly, biweekly, monthly }

abstract class AddScheduleState extends Equatable {
  const AddScheduleState();

  @override
  List<Object?> get props => [];
}

class AddScheduleInitial extends AddScheduleState {}

class AddScheduleLoading extends AddScheduleState {}

class AddScheduleLoaded extends AddScheduleState {
  final String message;
  final bool loading;
  final DateTime date;
  final List<TeamMemberModel> team;
  final Recurrencetypes recurrenceType;
  final List<CustomerModel> customers;
  final CustomerModel? customerSelected;
  final TeamMemberModel? memberSelected;
  final List<ServicesModel> services;
  final List<ProductsModel> products;
  final List<CombosModel> combos;
  final List<ServicesModel> selectedServices;
  final List<ProductsModel> selectedProducts;
  final List<CombosModel> selectedCombos;
  final int currentStep;
  final String? blockName;
  final String? blockNotes;
  final int? blockDuration;
  final DetailedBookingModel? booking;
  final DateTime? paymentDateTime;
  final PaymentMethods? selectedPaymentMethod;

  const AddScheduleLoaded({
    this.message = '',
    this.loading = false,
    required this.date,
    required this.team,
    this.recurrenceType = Recurrencetypes.none,
    required this.customers,
    this.customerSelected,
    this.memberSelected,
    this.services = const [],
    this.products = const [],
    this.combos = const [],
    this.selectedServices = const [],
    this.selectedProducts = const [],
    this.selectedCombos = const [],
    this.currentStep = 1,
    this.blockName,
    this.blockNotes,
    this.blockDuration,
    this.booking,
    this.paymentDateTime,
    this.selectedPaymentMethod,
  });

  AddScheduleLoaded copyWith({
    ValueGetter<String>? message,
    ValueGetter<bool>? loading,
    ValueGetter<DateTime>? date,
    ValueGetter<List<TeamMemberModel>>? team,
    ValueGetter<Recurrencetypes>? recurrenceType,
    ValueGetter<List<CustomerModel>>? customers,
    ValueGetter<CustomerModel?>? customerSelected,
    ValueGetter<TeamMemberModel?>? memberSelected,
    ValueGetter<List<ServicesModel>>? services,
    ValueGetter<List<ProductsModel>>? products,
    ValueGetter<List<CombosModel>>? combos,
    ValueGetter<List<ServicesModel>>? selectedServices,
    ValueGetter<List<ProductsModel>>? selectedProducts,
    ValueGetter<List<CombosModel>>? selectedCombos,
    ValueGetter<int>? currentStep,
    ValueGetter<String?>? blockName,
    ValueGetter<String?>? blockNotes,
    ValueGetter<int?>? blockDuration,
    ValueGetter<DetailedBookingModel?>? booking,
    ValueGetter<DateTime?>? paymentDateTime,
    ValueGetter<PaymentMethods?>? selectedPaymentMethod,
  }) {
    return AddScheduleLoaded(
      message: message != null ? message() : this.message,
      loading: loading != null ? loading() : this.loading,
      date: date != null ? date() : this.date,
      team: team != null ? team() : this.team,
      recurrenceType: recurrenceType != null
          ? recurrenceType()
          : this.recurrenceType,
      customers: customers != null ? customers() : this.customers,
      customerSelected: customerSelected != null
          ? customerSelected()
          : this.customerSelected,
      memberSelected: memberSelected != null
          ? memberSelected()
          : this.memberSelected,
      services: services != null ? services() : this.services,
      products: products != null ? products() : this.products,
      combos: combos != null ? combos() : this.combos,
      selectedServices: selectedServices != null ? selectedServices() : this.selectedServices,
      selectedProducts: selectedProducts != null ? selectedProducts() : this.selectedProducts,
      selectedCombos: selectedCombos != null ? selectedCombos() : this.selectedCombos,
      currentStep: currentStep != null ? currentStep() : this.currentStep,
      blockName: blockName != null ? blockName() : this.blockName,
      blockNotes: blockNotes != null ? blockNotes() : this.blockNotes,
      blockDuration: blockDuration != null ? blockDuration() : this.blockDuration,
      booking: booking != null ? booking() : this.booking,
      paymentDateTime: paymentDateTime != null ? paymentDateTime() : this.paymentDateTime,
      selectedPaymentMethod: selectedPaymentMethod != null ? selectedPaymentMethod() : this.selectedPaymentMethod,
    );
  }

  @override
  List<Object?> get props => [
    message,
    loading,
    date,
    team,
    recurrenceType,
    customers,
    customerSelected,
    memberSelected,
    services,
    products,
    combos,
    selectedServices,
    selectedProducts,
    selectedCombos,
    currentStep,
    blockName,
    blockNotes,
    blockDuration,
    booking,
    paymentDateTime,
    selectedPaymentMethod,
  ];
}

class AddScheduleEmpty extends AddScheduleState {}

class AddScheduleFailure extends AddScheduleState {}

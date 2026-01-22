part of 'add_schedule_bloc.dart';

abstract class AddScheduleEvent extends Equatable {
  const AddScheduleEvent();

  @override
  List<Object?> get props => [];
}

class AddScheduleLoadRequested extends AddScheduleEvent {
  final DateTime? initialDate;
  final String? bookingId;
  final String? blockId;

  const AddScheduleLoadRequested(
    this.initialDate, {
    this.bookingId,
    this.blockId,
  });

  @override
  List<Object?> get props => [initialDate, bookingId, blockId];
}

class CloseMessage extends AddScheduleEvent {}

class RefreshCustomers extends AddScheduleEvent {}

class SelectDate extends AddScheduleEvent {
  final DateTime date;

  const SelectDate({required this.date});

  @override
  List<Object?> get props => [date];
}

class RecurrenceTypeSelected extends AddScheduleEvent {
  final Recurrencetypes type;

  const RecurrenceTypeSelected({required this.type});

  @override
  List<Object?> get props => [type];
}

class SelectCustomer extends AddScheduleEvent {
  final CustomerModel customer;

  const SelectCustomer({required this.customer});

  @override
  List<Object?> get props => [customer];
}

class SelectMember extends AddScheduleEvent {
  final TeamMemberModel member;

  const SelectMember({required this.member});

  @override
  List<Object?> get props => [member];
}

class SelectServices extends AddScheduleEvent {
  final List<ServicesModel> services;
  final List<ProductsModel> products;
  final List<CombosModel> combos;

  const SelectServices({
    required this.services,
    required this.products,
    required this.combos,
  });

  @override
  List<Object?> get props => [services, products, combos];
}

class ClearServices extends AddScheduleEvent {}

class NextStep extends AddScheduleEvent {}

class PreviousStep extends AddScheduleEvent {}

class SelectTime extends AddScheduleEvent {
  final DateTime dateTime;

  const SelectTime({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class SubmitSchedule extends AddScheduleEvent {
  final CreateBookingResponse booking;

  const SubmitSchedule(this.booking);

  @override
  List<Object?> get props => [booking];
}

class SubmitBlock extends AddScheduleEvent {
  final CreateBlockResponse block;

  const SubmitBlock(this.block);

  @override
  List<Object?> get props => [block];
}

class DeleteBooking extends AddScheduleEvent {
  final String id;

  const DeleteBooking(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteBlock extends AddScheduleEvent {
  final String id;

  const DeleteBlock(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateBooking extends AddScheduleEvent {
  final CreateBookingResponse booking;
  final String id;

  const UpdateBooking(this.booking, this.id);

  @override
  List<Object?> get props => [booking, id];
}

class UpdateBlock extends AddScheduleEvent {
  final CreateBlockResponse block;
  final String id;

  const UpdateBlock(this.block, this.id);
  @override
  List<Object?> get props => [block, id];
}

class SelectPaymentDateTime extends AddScheduleEvent {}

class SelectPaymentMethod extends AddScheduleEvent {
  final PaymentMethods method;

  const SelectPaymentMethod({required this.method});

  @override
  List<Object?> get props => [method];
}

class MarkAsPaid extends AddScheduleEvent {
  final String bookingId;
  final String paymentDateTime;
  final String paymentMethod;
  final String notes;

  const MarkAsPaid({
    required this.bookingId,
    required this.paymentDateTime,
    required this.paymentMethod,
    required this.notes,
  });

  @override
  List<Object?> get props => [bookingId, paymentDateTime, paymentMethod, notes];
}

import 'package:hibeauty/features/schedules/data/model.dart';

abstract class SchedulesRepository {
  Future<void> getSchedulesDay({String? date});
  Future<void> getSchedulesWeek({String? date});
  Future<void> getSchedulesMonth({String? date});
  Future<SchedulesModel> getScheduleById(String id);
  Future<SchedulesModel> getBlockById(String id);
  Future<void> createBooking(CreateBookingResponse model);
  Future<void> createBlock(CreateBlockResponse model);
  Future<void> deleteBooking(String id);
  Future<void> deleteBlock(String id);
  Future<void> updateBooking(CreateBookingResponse model, String id);
  Future<void> updateBlock(CreateBlockResponse model, String id);
  Future<void> markAsPaid(String id, String paymentMethod, String notes, String paidAt);
}

class GetSchedulesDay {
  final SchedulesRepository repository;
  GetSchedulesDay(this.repository);

  Future<void> call({String? date}) {
    return repository.getSchedulesDay(date: date);
  }
}

class GetSchedulesWeek {
  final SchedulesRepository repository;
  GetSchedulesWeek(this.repository);

  Future<void> call({String? date}) {
    return repository.getSchedulesWeek(date: date);
  }
}

class GetSchedulesMonth {
  final SchedulesRepository repository;
  GetSchedulesMonth(this.repository);

  Future<void> call({String? date}) {
    return repository.getSchedulesMonth(date: date);
  }
}

class CreateBooking {
  final SchedulesRepository repository;
  CreateBooking(this.repository);

  Future<void> call(CreateBookingResponse model) {
    return repository.createBooking(model);
  }
}

class CreateBlock {
  final SchedulesRepository repository;
  CreateBlock(this.repository);

  Future<void> call(CreateBlockResponse model) {
    return repository.createBlock(model);
  }
}

class GetScheduleById {
  final SchedulesRepository repository;
  GetScheduleById(this.repository);

  Future<SchedulesModel> call(String id) {
    return repository.getScheduleById(id);
  }
}

class DeleteBooking {
  final SchedulesRepository repository;
  DeleteBooking(this.repository);

  Future<void> call(String id) {
    return repository.deleteBooking(id);
  }
}

class DeleteBlock {
  final SchedulesRepository repository;
  DeleteBlock(this.repository);

  Future<void> call(String id) {
    return repository.deleteBlock(id);
  }
}

class GetBlockById {
  final SchedulesRepository repository;
  GetBlockById(this.repository);

  Future<SchedulesModel> call(String id) {
    return repository.getBlockById(id);
  }
}

class UpdateBooking {
  final SchedulesRepository repository;
  UpdateBooking(this.repository);

  Future<void> call(CreateBookingResponse model, String id) {
    return repository.updateBooking(model, id);
  }
}

class UpdateBlock {
  final SchedulesRepository repository;
  UpdateBlock(this.repository);

  Future<void> call(CreateBlockResponse model, String id) {
    return repository.updateBlock(model, id);
  }
}

class MarkAsPaid {
  final SchedulesRepository repository;
  MarkAsPaid(this.repository);

  Future<void> call(String id, String paymentMethod, String notes, String paidAt) {
    return repository.markAsPaid(id, paymentMethod, notes, paidAt);
  }
}

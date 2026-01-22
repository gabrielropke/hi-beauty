import 'package:hibeauty/core/constants/failures.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import '../domain/repository.dart';
import 'data_source.dart';

class SchedulesRepositoryImpl implements SchedulesRepository {
  final SchedulesRemoteDataSource remote;

  SchedulesRepositoryImpl(this.remote);

  @override
  Future<void> getSchedulesDay({String? date}) async {
    try {
      await remote.getSchedulesDay(date: date);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> getSchedulesWeek({String? date}) async {
    try {
      await remote.getSchedulesWeek(date: date);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> getSchedulesMonth({String? date}) async {
    try {
      await remote.getSchedulesMonth(date: date);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createBooking(CreateBookingResponse model) async {
    try {
      await remote.createBooking(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> createBlock(CreateBlockResponse model) async {
    try {
      await remote.createBlock(model);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SchedulesModel> getScheduleById(String id) async {
    try {
      return await remote.getScheduleById(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteBooking(String id) async {
    try {
      await remote.deleteBooking(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> deleteBlock(String id) async {
    try {
      await remote.deleteBlock(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SchedulesModel> getBlockById(String id) async {
    try {
      return await remote.getBlockById(id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateBooking(CreateBookingResponse model, String id) async {
    try {
      await remote.updateBooking(model, id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> updateBlock(CreateBlockResponse model, String id) async {
    try {
      await remote.updateBlock(model, id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markAsPaid(
    String id,
    String paymentMethod,
    String notes,
    String paidAt,
  ) async {
    try {
      await remote.markAsPaid(id, paymentMethod, notes, paidAt);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

import 'dart:convert';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/data/base_remote_data_source.dart';
import 'package:hibeauty/core/data/user.dart';
import 'model.dart';

abstract class SchedulesRemoteDataSource {
  Future<SchedulesTodayResponseModel> getSchedulesDay({String? date});
  Future<BookingWeekORMonthModel> getSchedulesWeek({String? date});
  Future<BookingWeekORMonthModel> getSchedulesMonth({String? date});
  Future<SchedulesModel> getScheduleById(String id);
  Future<SchedulesModel> getBlockById(String id);
  Future<void> createBooking(CreateBookingResponse model);
  Future<void> createBlock(CreateBlockResponse model);
  Future<void> deleteBooking(String id);
  Future<void> deleteBlock(String id);
  Future<void> updateBooking(CreateBookingResponse model, String id);
  Future<void> updateBlock(CreateBlockResponse model, String id);
  Future<void> markAsPaid(
    String id,
    String paymentMethod,
    String notes,
    String paidAt,
  );
}

class SchedulesRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SchedulesRemoteDataSource {
  SchedulesRemoteDataSourceImpl({super.client, super.baseUrl, super.timeout});

  /// Ajusta o horário adicionando ou subtraindo 3 horas
  String _adjustTime(String dateTimeString, int hours) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      final adjustedDateTime = dateTime.add(Duration(hours: hours));
      return adjustedDateTime.toIso8601String();
    } catch (e) {
      return dateTimeString; // Retorna o original em caso de erro
    }
  }

  /// Ajusta horários em um mapa de dados (usado para responses com múltiplos bookings)
  Map<String, dynamic> _adjustTimesInResponse(
    Map<String, dynamic> data,
    int hours,
  ) {
    final adjustedData = Map<String, dynamic>.from(data);

    // Ajustar bookings se existir
    if (adjustedData['bookings'] is List) {
      adjustedData['bookings'] = (adjustedData['bookings'] as List)
          .map((booking) => _adjustTimeInBooking(booking, hours))
          .toList();
    }

    // Ajustar booking único se existir
    if (adjustedData['booking'] is Map) {
      adjustedData['booking'] = _adjustTimeInBooking(
        adjustedData['booking'],
        hours,
      );
    }

    // Ajustar timeBlock se existir
    if (adjustedData['timeBlock'] is Map) {
      adjustedData['timeBlock'] = _adjustTimeInBooking(
        adjustedData['timeBlock'],
        hours,
      );
    }

    // Ajustar bookingsByDay se existir
    if (adjustedData['bookingsByDay'] is List) {
      adjustedData['bookingsByDay'] = (adjustedData['bookingsByDay'] as List)
          .map((day) {
            if (day is Map<String, dynamic> && day['bookings'] is List) {
              final adjustedDay = Map<String, dynamic>.from(day);
              adjustedDay['bookings'] = (day['bookings'] as List)
                  .map((booking) => _adjustTimeInBooking(booking, hours))
                  .toList();
              return adjustedDay;
            }
            return day;
          })
          .toList();
    }

    return adjustedData;
  }

  /// Ajusta horário em um booking individual
  Map<String, dynamic> _adjustTimeInBooking(dynamic booking, int hours) {
    if (booking is! Map<String, dynamic>) return booking;

    final adjustedBooking = Map<String, dynamic>.from(booking);
    if (adjustedBooking['scheduledFor'] is String) {
      adjustedBooking['scheduledFor'] = _adjustTime(
        adjustedBooking['scheduledFor'],
        hours,
      );
    }
    return adjustedBooking;
  }

  @override
  Future<SchedulesTodayResponseModel> getSchedulesDay({String? date}) async {
    final queryParams = <String, String>{};

    if (date != null && date.isNotEmpty) {
      queryParams['date'] = date;
    }

    final uri = buildUri('v1/booking/today', queryParams);

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    // Ajustar horários subtraindo 3 horas
    final adjustedData = _adjustTimesInResponse(decoded, -3);

    return SchedulesTodayResponseModel.fromJson(adjustedData);
  }

  @override
  Future<SchedulesModel> getBlockById(String id) async {
    final uri = buildUri('v1/booking/blocks/$id');

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

    // Ajustar horários subtraindo 3 horas
    final adjustedData = _adjustTimesInResponse(decoded, -3);

    final result = SchedulesModel.fromJson(adjustedData);

    return result;
  }

  @override
  Future<SchedulesModel> getScheduleById(String id) async {
    final uri = buildUri('v1/booking/$id');

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    // Ajustar horários subtraindo 3 horas
    final adjustedData = _adjustTimesInResponse(decoded, -3);

    return SchedulesModel.fromJson(adjustedData);
  }

  @override
  Future<BookingWeekORMonthModel> getSchedulesWeek({String? date}) async {
    final queryParams = <String, String>{};

    if (date != null && date.isNotEmpty) {
      queryParams['weekStart'] = date;
    }

    final uri = buildUri('v1/booking/week', queryParams);

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;

    // Ajustar horários subtraindo 3 horas
    final adjustedData = _adjustTimesInResponse(decoded, -3);

    return BookingWeekORMonthModel.fromJson(adjustedData);
  }

  @override
  Future<BookingWeekORMonthModel> getSchedulesMonth({String? date}) async {
    final queryParams = <String, String>{};

    String? monthDate;
    if (date != null && date.isNotEmpty) {
      // Extrai apenas yyyy-mm
      final parts = date.split('-');
      if (parts.length >= 2) {
        monthDate = '${parts[0]}-${parts[1]}';
      } else {
        monthDate = date;
      }
      queryParams['month'] = monthDate;
    }

    final uri = buildUri('v1/booking/month', queryParams);

    final res = await getJson(
      uri,
      headers: {
        'accept': 'application/json',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;

    final decoded =
        jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
    // Ajustar horários subtraindo 3 horas
    final adjustedData = _adjustTimesInResponse(decoded, -3);
    return BookingWeekORMonthModel.fromJson(adjustedData);
  }

  @override
  Future<void> markAsPaid(
    String id,
    String paymentMethod,
    String notes,
    String paidAt,
  ) async {
    final uri = buildUri('v1/booking/$id/mark-as-paid');

    final body = {
      "paymentMethod": paymentMethod,
      "notes": notes,
      "paidAt": paidAt,
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
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> createBooking(CreateBookingResponse model) async {
    final uri = buildUri('v1/booking');

    // Criar uma cópia do model com horário ajustado (+3 horas)
    final adjustedModel = CreateBookingResponse(
      name: model.name,
      notes: model.notes,
      scheduledFor: _adjustTime(model.scheduledFor, 3),
      customerId: model.customerId,
      teamMemberId: model.teamMemberId,
      services: model.services,
      combos: model.combos,
      products: model.products,
      discount: model.discount,
      recurrenceType: model.recurrenceType,
      recurrenceEndDate: model.recurrenceEndDate,
    );

    final body = adjustedModel.toJson();

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
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> updateBooking(CreateBookingResponse model, String id) async {
    final uri = buildUri('v1/booking/$id');

    // Criar uma cópia do model com horário ajustado (+3 horas)
    final adjustedModel = CreateBookingResponse(
      name: model.name,
      notes: model.notes,
      scheduledFor: _adjustTime(model.scheduledFor, 3),
      customerId: model.customerId,
      teamMemberId: model.teamMemberId,
      services: model.services,
      combos: model.combos,
      products: model.products,
      discount: model.discount,
      recurrenceType: model.recurrenceType,
      recurrenceEndDate: model.recurrenceEndDate,
    );

    final body = adjustedModel.toJson();

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
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> createBlock(CreateBlockResponse model) async {
    final uri = buildUri('v1/booking/blocks');

    // Criar uma cópia do model com horário ajustado (+3 horas)
    final adjustedModel = CreateBlockResponse(
      name: model.name,
      teamMemberId: model.teamMemberId,
      scheduledFor: _adjustTime(model.scheduledFor, 3),
      duration: model.duration,
      notes: model.notes,
      recurrenceType: model.recurrenceType,
      recurrenceEndDate: model.recurrenceEndDate,
    );

    final body = adjustedModel.toJson();

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
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> updateBlock(CreateBlockResponse model, String id) async {
    final uri = buildUri('v1/booking/blocks/$id');

    // Criar uma cópia do model com horário ajustado (+3 horas)
    final adjustedModel = CreateBlockResponse(
      name: model.name,
      teamMemberId: model.teamMemberId,
      scheduledFor: _adjustTime(model.scheduledFor, 3),
      duration: model.duration,
      notes: model.notes,
      recurrenceType: model.recurrenceType,
      recurrenceEndDate: model.recurrenceEndDate,
    );

    final body = adjustedModel.toJson();

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
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> deleteBooking(String id) async {
    final uri = buildUri('v1/booking/$id');

    final res = await deleteJson(
      uri,
      body: {"removeScope": "SINGLE", "reason": "Item cancelado"},
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }

  @override
  Future<void> deleteBlock(String id) async {
    final uri = buildUri('v1/booking/blocks/$id/remove');

    final res = await deleteJson(
      uri,
      body: {"removeScope": "SINGLE", "reason": "Horário liberado"},
      headers: {
        'accept': '*/*',
        'X-Brand-Id': await BrandLoader.getBrandHeader(),
        'Authorization': 'Bearer ${UserData.userSessionToken}',
      },
    );

    final apiFailure = ApiFailure.fromResponse(res);
    if (!apiFailure.ok) throw apiFailure;
  }
}

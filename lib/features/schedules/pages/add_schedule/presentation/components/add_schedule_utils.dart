import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';

String recurrenceTypesToString(Recurrencetypes type) {
  switch (type) {
    case Recurrencetypes.none:
      return 'Não se repete';
    case Recurrencetypes.daily:
      return 'Diariamente';
    case Recurrencetypes.weekdays:
      return 'Dias úteis';
    case Recurrencetypes.weekly:
      return 'Semanal';
    case Recurrencetypes.biweekly:
      return 'Quinzenal';
    case Recurrencetypes.monthly:
      return 'Mensal';
  }
}

enum AddScheduleType { booking, block }

String getAddScheduleTypeString(AddScheduleType type) {
  switch (type) {
    case AddScheduleType.booking:
      return 'Novo agendamento';
    case AddScheduleType.block:
      return 'Bloquear horário';
  }
}
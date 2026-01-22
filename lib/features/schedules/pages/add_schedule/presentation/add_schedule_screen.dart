import 'package:flutter/material.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_booking_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_block_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';

class AddScheduleArgs {
  final AddScheduleType addScheduleType;
  final DateTime? initialDate;
  final String? bookingId;

  AddScheduleArgs({
    required this.addScheduleType,
    this.initialDate,
    this.bookingId,
  });
}

class AddScheduleScreen extends StatelessWidget {
  final AddScheduleType addScheduleType;
  final DateTime? initialDate;
  final String? id;

  const AddScheduleScreen({
    super.key,
    required this.addScheduleType,
    this.initialDate,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    switch (addScheduleType) {
      case AddScheduleType.booking:
        final bookingArgs = AddScheduleArgs(
          addScheduleType: addScheduleType,
          initialDate: initialDate,
          bookingId: id,
        );
        return AddScheduleBookingScreen(initialDate: initialDate, args: bookingArgs);
      case AddScheduleType.block:
        final blockArgs = AddScheduleBlockArgs(
          initialDate: initialDate,
          blockId: id,
          isEditing: id != null,
        );
        return AddScheduleBlockScreen(initialDate: initialDate, args: blockArgs);
    }
  }
}

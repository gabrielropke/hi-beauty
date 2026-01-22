import 'package:flutter/material.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TimeResume extends StatelessWidget {
  final AddScheduleLoaded state;
  final bool isEditing;
  const TimeResume({super.key, required this.state, required this.isEditing});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
        child: Column(
          spacing: 22,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  spacing: 10,
                  children: [
                    Icon(LucideIcons.calendar300, size: 20),
                    Text(
                      DateFormatters.weekdayDayMonthShort(state.date, context),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    Icon(LucideIcons.clock3, size: 20),
                    Text(DateFormatters.timeFormat(state.date)),
                  ],
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
            ),
            Row(
              spacing: 10,
              children: [
                Icon(LucideIcons.repeat300, size: 20),
                Text(recurrenceTypesToString(state.recurrenceType)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

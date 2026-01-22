import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NextAppointments extends StatelessWidget {
  final DashboardLoaded state;
  const NextAppointments({super.key, required this.state});

  String _getDateLabel(DateTime appointmentDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final appointmentDay = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
    );

    if (appointmentDay == today) {
      return 'Hoje';
    } else if (appointmentDay == tomorrow) {
      return 'Amanhã';
    } else {
      return DateFormatters.formatarDataComDia('$appointmentDate');
    }
  }

  bool _shouldShowDate(List appointments, int index) {
    if (index == 0) return true;

    final currentDate = DateTime(
      appointments[index].scheduledFor.year,
      appointments[index].scheduledFor.month,
      appointments[index].scheduledFor.day,
    );

    final previousDate = DateTime(
      appointments[index - 1].scheduledFor.year,
      appointments[index - 1].scheduledFor.month,
      appointments[index - 1].scheduledFor.day,
    );

    return currentDate != previousDate;
  }

  String _getDayText(DateTime date) {
    return date.day.toString();
  }

  String _getMonthText(DateTime date) {
    const months = [
      '',
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];
    return months[date.month];
  }

  @override
  Widget build(BuildContext context) {
    final appointments = state.data?.upcomingAppointments ?? [];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                'Próximos na agenda',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              
              if (appointments.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Nenhum agendamento até o momento',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 18),
                  itemCount: appointments.length > 10
                      ? 10
                      : appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return GestureDetector(
                      onTap: () => context.push(
                        AppRoutes.addSchedule,
                        extra: AddScheduleArgs(
                          addScheduleType: AddScheduleType.booking,
                          bookingId: appointment.id,
                        ),
                      ),
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 12,
                              child: _shouldShowDate(appointments, index)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _getDayText(appointment.scheduledFor),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          _getMonthText(
                                            appointment.scheduledFor,
                                          ),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(width: 0),
                            ),
                            Expanded(
                              flex: 90,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${DateFormatters.weekdayDayMonthShort(appointment.scheduledFor, context)} às ${DateFormatters.timeFormat(appointment.scheduledFor)}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13,
                                              ),
                                            ),
                
                                            Text(
                                              appointment.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                              child: Text(
                                                _getDateLabel(
                                                  appointment.scheduledFor,
                                                ),
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${appointment.customer.name.split(' ')[0]}, atendimento com ${appointment.teamMember.name.split(' ')[0]}',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        LucideIcons.chevronRight300,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  Opacity(
                                    opacity: index < appointments.length - 1
                                        ? 1.0
                                        : 0.0,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical:
                                            index < appointments.length - 1
                                            ? 20.0
                                            : 10,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 0.5,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

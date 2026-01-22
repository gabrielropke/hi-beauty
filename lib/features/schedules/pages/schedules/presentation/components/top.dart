import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/core/data/user.dart';
import 'package:hibeauty/core/services/notifications_service.dart';
import 'package:hibeauty/features/home/presentation/bloc/home_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/date_picker.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/team_members_list.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TimelineTop extends StatelessWidget {
  final BuildContext bcontext;
  final SchedulesLoaded state;

  const TimelineTop({super.key, required this.state, required this.bcontext});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Column(
        spacing: 12,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Comunica com o HomeBloc para abrir o drawer
                      context.read<HomeBloc>().add(
                        OpenSchedulesDrawer(
                          schedulesState: state,
                          schedulesContext: bcontext,
                        ),
                      );
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.transparent,
                      child: Icon(LucideIcons.panelBottom300),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showTimelineCalendarSheet(
                      bcontext: bcontext,
                      state: state,
                    ),
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          spacing: 4,
                          children: [
                            Text(() {
                              final type = state.timelineType;
                              if (type == TimeLineType.day) {
                                return DateFormatters.weekdayDayMonth(
                                  state.date,
                                  context,
                                );
                              }

                              const shortMonths = [
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
                              const longMonths = [
                                'Janeiro',
                                'Fevereiro',
                                'Março',
                                'Abril',
                                'Maio',
                                'Junho',
                                'Julho',
                                'Agosto',
                                'Setembro',
                                'Outubro',
                                'Novembro',
                                'Dezembro',
                              ];

                              String rangeLabel(DateTime start, DateTime end) {
                                final sDay = start.day.toString();
                                final eDay = end.day.toString();
                                if (start.month == end.month &&
                                    start.year == end.year) {
                                  return '$sDay - $eDay ${shortMonths[start.month - 1]}';
                                } else {
                                  return '$sDay ${shortMonths[start.month - 1]} - $eDay ${shortMonths[end.month - 1]}';
                                }
                              }

                              if (type == TimeLineType.threeDays) {
                                final start = state.date;
                                final end = start.add(const Duration(days: 2));
                                return rangeLabel(start, end);
                              }

                              if (type == TimeLineType.week) {
                                final start = state.date;
                                final end = start.add(const Duration(days: 6));
                                return rangeLabel(start, end);
                              }

                              if (type == TimeLineType.month) {
                                final d = state.date;
                                return '${longMonths[d.month - 1]} ${d.year}';
                              }

                              return '';
                            }()),
                            Icon(LucideIcons.chevronDown300, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  NotificationsService().notificationGlobalWidget(context),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.user),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondary, width: 1),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.black12,
                          backgroundImage: UserData.profileImageUrl.isNotEmpty
                              ? NetworkImage(UserData.profileImageUrl)
                              : null,
                          child: UserData.profileImageUrl.isEmpty
                              ? Text(
                                  (UserData.name.isNotEmpty
                                          ? UserData.name[0]
                                          : '?')
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                ],
              ),
            ],
          ),
          if (state.timelineType == TimeLineType.day)
            TimelineMembers(members: state.team.teamMembers),
          if (state.timelineType == TimeLineType.threeDays) _buildDateHeaders(),
          if (state.timelineType == TimeLineType.week) _buildDateHeaders(),
          if (state.timelineType == TimeLineType.month) ...[_buildWeekHeader()],
        ],
      ),
    );
  }

  Widget _dateHeader(DateTime date) {
    final dayName = _getDayNameShort(date.weekday);
    final dayNumber = date.day.toString().padLeft(2, '0');
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final numberColor = isToday ? Colors.white : Colors.grey;
    final nameColor = isToday ? AppColors.primary : Colors.grey;
    final fontWeight = isToday ? FontWeight.w600 : FontWeight.w500;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            color: isToday ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            dayNumber,
            style: TextStyle(
              fontSize: 13,
              color: numberColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
        Text(
          dayName.toLowerCase(),
          style: TextStyle(
            fontSize: 10,
            color: nameColor,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }

  String _getDayNameShort(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'DOM';
      case DateTime.monday:
        return 'SEG';
      case DateTime.tuesday:
        return 'TER';
      case DateTime.wednesday:
        return 'QUA';
      case DateTime.thursday:
        return 'QUI';
      case DateTime.friday:
        return 'SEX';
      case DateTime.saturday:
        return 'SÁB';
      default:
        return 'SEG';
    }
  }

  Widget _buildDateHeaders() {
    switch (state.timelineType) {
      case TimeLineType.day:
        return Row(
          children: [
            SizedBox(width: 45), // Espaço para os horários
            Expanded(child: _dateHeader(state.date)),
          ],
        );

      case TimeLineType.threeDays:
        return Row(
          children: [
            SizedBox(width: 45),
            Expanded(child: _dateHeader(state.date)),
            Expanded(
              child: _dateHeader(state.date.add(const Duration(days: 1))),
            ),
            Expanded(
              child: _dateHeader(state.date.add(const Duration(days: 2))),
            ),
          ],
        );

      case TimeLineType.week:
        return Row(
          children: [
            SizedBox(width: 50),
            for (int i = 0; i < 7; i++)
              Expanded(child: _dateHeader(state.date.add(Duration(days: i)))),
          ],
        );

      case TimeLineType.month:
        throw UnimplementedError();
    }
  }

  Widget _buildWeekHeader() {
    const weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];

    return Row(
      children: weekDays.map((day) {
        return Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              day,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

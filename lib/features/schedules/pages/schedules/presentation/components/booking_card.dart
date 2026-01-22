import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final double pixelsPerMinute;
  final int conflictIndex;
  final int totalConflicts;
  final SchedulesLoaded state;

  const BookingCard({
    super.key,
    required this.booking,
    required this.pixelsPerMinute,
    this.conflictIndex = 0,
    this.totalConflicts = 1,
    required this.state,
  });

  Color _parseColor(String colorString) {
    try {
      if (colorString.isEmpty) return Colors.blue;
      final color = colorString.replaceFirst('#', '');
      final fullColor = color.length == 6 ? 'FF$color' : color;
      return Color(int.parse('0x$fullColor'));
    } catch (e) {
      return Colors.blue;
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getTimeRange() {
    TimeLineType type = state.timelineType;

    try {
      final startTime = DateTime.parse(
        booking.scheduledFor,
      );

      if (type == TimeLineType.week) {
        return _formatTime(startTime);
      }

      final endTime = startTime.add(Duration(minutes: booking.duration));
      return '${_formatTime(startTime)} - ${_formatTime(endTime)}';
    } catch (e) {
      return 'Horário inválido';
    }
  }

  String _getServiceType() {
    if (booking.services.isNotEmpty) {
      return booking.services.first.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final height = booking.duration * pixelsPerMinute;
    final teamMemberColor = _parseColor(booking.teamMember.color);
    final isCompact = totalConflicts > 1;
    final timeRange = _getTimeRange();
    final customerName = booking.customer.name;
    final serviceType = _getServiceType();

    return GestureDetector(
      onTap: () {
        booking.type == 'BOOKING'
            ? context.push(
                AppRoutes.addSchedule,
                extra: AddScheduleArgs(
                  addScheduleType: AddScheduleType.booking,
                  bookingId: booking.id,
                  initialDate: DateTime.parse(booking.scheduledFor),
                ),
              )
            : context.push(
                AppRoutes.addSchedule,
                extra: AddScheduleArgs(
                  addScheduleType: AddScheduleType.block,
                  bookingId: booking.id,
                ),
              );
      },
      child: Container(
        height: height,
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: teamMemberColor.withValues(alpha: 0.5),
          border: Border(left: BorderSide(color: teamMemberColor, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isCompact ? 4 : 4),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Horário e Cliente
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final timeText = Flexible(
                            child: Text(
                              timeRange,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
                              ),
                            ),
                          );

                          final customerText = customerName.isNotEmpty
                              ? Text(
                                  customerName,
                                  style: TextStyle(
                                    fontSize: isCompact ? 11 : 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null;

                          // Verifica se cabe em uma Row ou precisa usar Column
                          if (customerText != null &&
                              constraints.maxWidth > 120) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      timeText,
                                      const SizedBox(width: 8),
                                      Flexible(child: customerText),
                                    ],
                                  ),
                                ),
                                if (booking.duration < 30)
                                  _teamMemberIndicator(booking, isCompact, size: 22),
                              ],
                            );
                          } else {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    timeText,
                                    if (booking.duration < 30)
                                    _teamMemberIndicator(booking, isCompact, size: 22),
                                  ],
                                ),
                                if (customerText != null) ...[
                                  const SizedBox(height: 4),
                                  customerText,
                                ],
                              ],
                            );
                          }
                        },
                      ),
                      if (booking.type == 'BLOCK') ...[
                        const SizedBox(height: 6),
                        Text(
                          booking.name,
                          style: TextStyle(
                            fontSize: isCompact ? 10 : 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: isCompact ? 2 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      // Tipo de Serviço
                      const SizedBox(height: 6),
                      Text(
                        serviceType,
                        style: TextStyle(
                          fontSize: isCompact ? 10 : 11,
                          color: Colors.black54,
                        ),
                        maxLines: isCompact ? 2 : 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Team Member Indicator sempre no final
            if (booking.duration > 30)
              Padding(
                padding: EdgeInsets.all(isCompact ? 4 : 4),
                child: _teamMemberIndicator(booking, isCompact, showName: true),
              ),
          ],
        ),
      ),
    );
  }

  Widget _teamMemberIndicator(
    BookingModel booking,
    bool isCompact, {
    bool? showName,
    double? size,
  }) {
    double sized = size ?? (state.timelineType == TimeLineType.week ? 26 : 30);
    return Align(
      alignment: AlignmentGeometry.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: sized,
              height: sized,
              decoration: BoxDecoration(
                color: _parseColor(booking.teamMember.color),
                border: Border.all(color: Colors.white, width: 1.5),
                shape: BoxShape.circle,
              ),
              child: booking.teamMember.profileImageUrl.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        booking.teamMember.profileImageUrl,
                        fit: BoxFit.cover,
                        width: sized,
                        height: sized,
                      ),
                    )
                  : Center(
                      child: Text(
                        booking.teamMember.name.length >= 2
                            ? booking.teamMember.name
                                  .substring(0, 2)
                                  .toUpperCase()
                            : booking.teamMember.name.characters.first
                                  .toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
            ),
            if (showName == true)
              Flexible(
                child: Text(
                  booking.teamMember.name.split(' ')[0],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

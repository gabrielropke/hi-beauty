import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';

class CalendarSchedules extends StatelessWidget {
  final SchedulesLoaded state;

  const CalendarSchedules({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currentDate =
        state.date; // Usar a data do estado ao invés de DateTime.now()
    final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    // Domingo como primeiro dia (0)
    final firstWeekday = firstDayOfMonth.weekday == DateTime.sunday
        ? 0
        : firstDayOfMonth.weekday;

    return Expanded(
      child: _buildCalendarGrid(currentDate, firstWeekday, daysInMonth),
    );
  }

  // ─────────────────────────────────────────────────────────────

  Widget _buildCalendarGrid(
    DateTime currentDate,
    int firstWeekday,
    int daysInMonth,
  ) {
    final totalCells = firstWeekday + daysInMonth;
    final weeks = (totalCells / 7).ceil();

    return Column(
      children: List.generate(weeks, (weekIndex) {
        return Expanded(
          child: Row(
            children: List.generate(7, (dayIndex) {
              final cellIndex = weekIndex * 7 + dayIndex;

              if (cellIndex < firstWeekday ||
                  cellIndex >= firstWeekday + daysInMonth) {
                return const _EmptyDayCell();
              }

              final day = cellIndex - firstWeekday + 1;
              final date = DateTime(currentDate.year, currentDate.month, day);

              return _DayCell(
                day: day,
                date: date,
                isToday: _isSameDay(date, DateTime.now()),
                isClosed: !_isBusinessOpen(date),
                bookings: _getBookingsForDate(date),
              );
            }),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────────────────────

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<BookingModel> _getBookingsForDate(DateTime date) {
    if (state.bookingWeekOrMonth == null) return [];

    try {
      final targetDateStr =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final dayData = state.bookingWeekOrMonth!.bookingsByDay.firstWhere(
        (day) => day.date == targetDateStr,
      );

      return dayData.bookings;
    } catch (e) {
      return [];
    }
  }

  bool _isBusinessOpen(DateTime date) {
    final dayName = _getDayName(date.weekday);
    final openingHours = BusinessData.openingHours;

    if (openingHours.isEmpty) return true;

    try {
      final today = openingHours.firstWhere((e) => e.day == dayName);
      return today.open;
    } catch (_) {
      return true;
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.sunday:
        return 'Domingo';
      case DateTime.monday:
        return 'Segunda-feira';
      case DateTime.tuesday:
        return 'Terça-feira';
      case DateTime.wednesday:
        return 'Quarta-feira';
      case DateTime.thursday:
        return 'Quinta-feira';
      case DateTime.friday:
        return 'Sexta-feira';
      case DateTime.saturday:
        return 'Sábado';
      default:
        return '';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// COMPONENTES
// ─────────────────────────────────────────────────────────────

class _DayCell extends StatelessWidget {
  final int day;
  final DateTime date;
  final bool isToday;
  final bool isClosed;
  final List<BookingModel> bookings;

  const _DayCell({
    required this.day,
    required this.date,
    required this.isToday,
    required this.isClosed,
    required this.bookings,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          
          context.read<SchedulesBloc>().add(
            SelectTimelineType(timelineType: TimeLineType.day, date: date),
          );
          
        },
        child: Container(
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.white,
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.25),
              width: 0.5,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Número do dia
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: isToday
                          ? BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            )
                          : null,
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isToday ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Área scrollável para os indicadores de agendamentos
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildBookingIndicators(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isClosed) const Positioned.fill(child: IgnorePointer(child: _ClosedDayOverlay())),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBookingIndicators() {
    if (bookings.isEmpty) return [];

    final widgets = <Widget>[];

    // Exibir todos os agendamentos (sem limitação)
    for (final booking in bookings) {
      final startTime = _formatBookingTime(booking.scheduledFor);

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: parseColor(
                booking.teamMember.color,
              ).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              startTime,
              style: const TextStyle(
                fontSize: 9,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  String _formatBookingTime(String scheduledFor) {
    try {
      final dateTime = DateTime.parse(scheduledFor);
      // Remover 3 horas para converter de UTC para horário local
      final localDateTime = dateTime;
      return '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '--:--';
    }
  }
}

class _EmptyDayCell extends StatelessWidget {
  const _EmptyDayCell();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.05),
          border: Border.all(
            color: Colors.grey.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
      ),
    );
  }
}

class _ClosedDayOverlay extends StatelessWidget {
  const _ClosedDayOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: CustomPaint(painter: _DiagonalLinesPainter(), child: Container()),
    );
  }
}

class _DiagonalLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Criar um rect para limitar o desenho
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.clipRect(rect);

    // Desenhar linhas diagonais da esquerda para direita
    final spacing = 8.0;
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      final startPoint = Offset(i, 0);
      final endPoint = Offset(i + size.height, size.height);

      // Verificar se a linha está dentro dos limites antes de desenhar
      if (startPoint.dx < size.width || endPoint.dx > 0) {
        canvas.drawLine(startPoint, endPoint, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

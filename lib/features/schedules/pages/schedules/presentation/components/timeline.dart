import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/booking_card.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/hour_slot.dart';

class TimelineCalendar extends StatefulWidget {
  final List<BookingModel> bookings;
  final SchedulesLoaded state;
  final String? teamMemberId;
  const TimelineCalendar({
    super.key,
    this.bookings = const [],
    required this.state,
    this.teamMemberId,
  });

  @override
  State<TimelineCalendar> createState() => _TimelineCalendarState();
}

class _TimelineCalendarState extends State<TimelineCalendar> {
  static const double pixelsPerMinute = 1.8;

  late Timer _timer;
  DateTime now = DateTime.now();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => setState(() => now = DateTime.now()),
    );
    // Rolar automaticamente para centralizar o indicador atual na tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = this.context;
      if (context.mounted) {
        // Altura da viewport (altura da tela visível)
        final viewportHeight = MediaQuery.of(context).size.height;
        // Posição do indicador em pixels
        final indicatorPosition = _minutesFromStartOfDay() * pixelsPerMinute;
        // Calcular offset para centralizar o indicador
        final offset = indicatorPosition - (viewportHeight / 7);

        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            offset.clamp(0, _scrollController.position.maxScrollExtent),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  double _minutesFromStartOfDay() {
    return now.hour * 60 + now.minute.toDouble();
  }

  double _getBookingPosition(String scheduledFor) {
    try {
      final dateTime = DateTime.parse(scheduledFor);
      // Remover 3 horas para converter de UTC para horário local
      final localDateTime = dateTime;
      final minutes = localDateTime.hour * 60 + localDateTime.minute;
      return minutes * pixelsPerMinute;
    } catch (e) {
      return 0;
    }
  }

  bool _bookingsConflict(BookingModel a, BookingModel b) {
    try {
      final startA = DateTime.parse(
        a.scheduledFor,
      );
      final endA = startA.add(Duration(minutes: a.duration));
      final startB = DateTime.parse(
        b.scheduledFor,
      );
      final endB = startB.add(Duration(minutes: b.duration));

      // Verificar se há sobreposição
      return startA.isBefore(endB) && startB.isBefore(endA);
    } catch (e) {
      return false;
    }
  }

  List<BookingModel> _getBookingsForDate(DateTime targetDate) {
    return widget.bookings.where((booking) {
      try {
        final bookingDate = DateTime.parse(
          booking.scheduledFor,
        );
        return bookingDate.year == targetDate.year &&
            bookingDate.month == targetDate.month &&
            bookingDate.day == targetDate.day;
      } catch (e) {
        return false;
      }
    }).toList();
  }

  List<BookingModel> _getBookingsForDateWeek(DateTime date) {
    if (widget.state.bookingWeekOrMonth == null) return [];

    try {
      final targetDateStr =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final dayData = widget.state.bookingWeekOrMonth!.bookingsByDay.firstWhere(
        (day) => day.date == targetDateStr,
      );

      return dayData.bookings;
    } catch (e) {
      return [];
    }
  }

  List<Widget> _buildBookingWidgetsForColumn(
    DateTime date,
    double leftOffset,
    double columnWidth,
  ) {
    final bookingsForDate = _getBookingsForDate(date);
    final conflictGroups = _groupConflictingBookingsForDate(bookingsForDate);
    final widgets = <Widget>[];

    for (final group in conflictGroups) {
      if (group.length == 1) {
        final booking = group.first;
        final position = _getBookingPosition(booking.scheduledFor);
        widgets.add(
          Positioned(
            top: position,
            left: leftOffset,
            width: columnWidth,
            child: BookingCard(
              state: widget.state,
              booking: booking,
              pixelsPerMinute: pixelsPerMinute,
              conflictIndex: 0,
              totalConflicts: 1,
            ),
          ),
        );
      } else {
        final cardWidth = columnWidth / group.length;
        for (int i = 0; i < group.length; i++) {
          final booking = group[i];
          final position = _getBookingPosition(booking.scheduledFor);
          final cardLeftOffset = leftOffset + (i * cardWidth);

          widgets.add(
            Positioned(
              top: position,
              left: cardLeftOffset,
              width: cardWidth,
              child: BookingCard(
                state: widget.state,
                booking: booking,
                pixelsPerMinute: pixelsPerMinute,
                conflictIndex: i,
                totalConflicts: group.length,
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  List<List<BookingModel>> _groupConflictingBookingsForDate(
    List<BookingModel> bookings,
  ) {
    final groups = <List<BookingModel>>[];
    final processed = <BookingModel>{};

    for (final booking in bookings) {
      if (processed.contains(booking)) continue;

      final conflictGroup = [booking];
      processed.add(booking);

      for (final other in bookings) {
        if (processed.contains(other) || booking == other) continue;

        if (_bookingsConflict(booking, other)) {
          conflictGroup.add(other);
          processed.add(other);
        }
      }

      groups.add(conflictGroup);
    }

    return groups;
  }

  List<Widget> _buildAllBookingWidgets() {
    final screenWidth = MediaQuery.of(context).size.width;
    const hourLabelWidth = 45.0;
    final widgets = <Widget>[];

    switch (widget.state.timelineType) {
      case TimeLineType.day:
        final columnWidth = screenWidth - hourLabelWidth;
        widgets.addAll(
          _buildBookingWidgetsForColumn(
            widget.state.date,
            hourLabelWidth,
            columnWidth,
          ),
        );
        break;

      case TimeLineType.threeDays:
        const dividerWidth = 1.0;
        final availableWidth =
            screenWidth - hourLabelWidth - (2 * dividerWidth);
        final columnWidth = availableWidth / 3;

        // Coluna 1
        widgets.addAll(
          _buildBookingWidgetsForColumn(
            widget.state.date,
            hourLabelWidth,
            columnWidth,
          ),
        );

        // Coluna 2
        widgets.addAll(
          _buildBookingWidgetsForColumn(
            widget.state.date.add(const Duration(days: 1)),
            hourLabelWidth + columnWidth + dividerWidth,
            columnWidth,
          ),
        );

        // Coluna 3
        widgets.addAll(
          _buildBookingWidgetsForColumn(
            widget.state.date.add(const Duration(days: 2)),
            hourLabelWidth + (2 * columnWidth) + (2 * dividerWidth),
            columnWidth,
          ),
        );
        break;

      case TimeLineType.week:
        // Para semana, usamos uma estrutura diferente em _buildWeekContent
        // então não precisamos construir widgets aqui
        break;

      case TimeLineType.month:
        return [];
    }

    return widgets;
  }

  Widget _buildNormalContent() {
    return Stack(
      children: [
        Column(
          children: List.generate(24, (hour) {
            return HourSlot(
              hour: hour,
              pixelsPerMinute: pixelsPerMinute,
              state: widget.state,
            );
          }),
        ),
        // Bookings
        ..._buildAllBookingWidgets(),
        // Indicadores Now posicionados por coluna
        ..._buildNowIndicators(),
      ],
    );
  }

  Widget _buildWeekContent() {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(7, (index) {
          final date = widget.state.date.add(Duration(days: index));
          return Expanded(child: _buildWeekColumn(date));
        }),
      ),
    );
  }

  Widget _buildWeekColumn(DateTime date) {
    final bookingsForDate = _getBookingsForDateWeek(date);
    final isClosed = !_isBusinessOpen(date);

    return Stack(
      children: [
        IgnorePointer(child: _ClosedDayOverlay(isClosed)),
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lista de agendamentos
                ...bookingsForDate.expand((booking) {
                  final indicators = _buildBookingIndicators([booking]);
                  return indicators;
                }),
                // Se não há agendamentos
                if (bookingsForDate.isEmpty) SizedBox.fromSize(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBookingIndicators(List<BookingModel> bookings) {
    if (bookings.isEmpty) return [];

    // Filtrar por teamMemberId se fornecido
    var filteredBookings = bookings;
    if (widget.teamMemberId != null) {
      filteredBookings = bookings
          .where((booking) => booking.teamMember.id == widget.teamMemberId)
          .toList();
    }

    if (filteredBookings.isEmpty) return [];

    final widgets = <Widget>[];

    // Exibir todos os agendamentos filtrados
    for (final booking in filteredBookings) {
      final startTime = _formatBookingTime(booking.scheduledFor);

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: GestureDetector(
            onTap: () {
              booking.type == 'BOOKING'
                  ? context.push(
                      AppRoutes.addSchedule,
                      extra: AddScheduleArgs(
                        addScheduleType: AddScheduleType.booking,
                        bookingId: booking.id,
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
        ),
      );
    }

    return widgets;
  }

  Color parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(
          int.parse(colorString.substring(1), radix: 16) + 0xFF000000,
        );
      }
      return Colors.blue; // Cor padrão
    } catch (e) {
      return Colors.blue; // Cor padrão se der erro
    }
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

  List<Widget> _buildNowIndicators() {
    final screenWidth = MediaQuery.of(context).size.width;
    const hourLabelWidth = 45.0;
    final widgets = <Widget>[];
    final today = DateTime.now();
    final indicatorTop = _minutesFromStartOfDay() * pixelsPerMinute;

    bool isSameDay(DateTime date1, DateTime date2) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    }

    switch (widget.state.timelineType) {
      case TimeLineType.day:
        final isToday = isSameDay(widget.state.date, today);
        widgets.add(
          Positioned(
            top: indicatorTop,
            left: 0,
            right: 0,
            child: _NowIndicator(time: now, isDashed: !isToday),
          ),
        );
        break;

      case TimeLineType.threeDays:
        const dividerWidth = 1.0;
        final availableWidth =
            screenWidth - hourLabelWidth - (2 * dividerWidth);
        final columnWidth = availableWidth / 3;

        for (int i = 0; i < 3; i++) {
          final columnDate = widget.state.date.add(Duration(days: i));
          final isToday = isSameDay(columnDate, today);
          final leftOffset =
              hourLabelWidth + (i * columnWidth) + (i * dividerWidth);

          widgets.add(
            Positioned(
              top: indicatorTop,
              left: leftOffset,
              width: columnWidth,
              child: _NowIndicator(
                time: now,
                isColumnIndicator: true,
                isDashed: !isToday,
              ),
            ),
          );
        }
        break;

      case TimeLineType.week:
        const dividerWidth = 1.0;
        final availableWidth =
            screenWidth - hourLabelWidth - (6 * dividerWidth);
        final columnWidth = availableWidth / 7;

        for (int i = 0; i < 7; i++) {
          final columnDate = widget.state.date.add(Duration(days: i));
          final isToday = isSameDay(columnDate, today);
          final leftOffset =
              hourLabelWidth + (i * columnWidth) + (i * dividerWidth);

          widgets.add(
            Positioned(
              top: indicatorTop,
              left: leftOffset,
              width: columnWidth,
              child: _NowIndicator(
                time: now,
                isColumnIndicator: true,
                isDashed: !isToday,
              ),
            ),
          );
        }
        break;

      case TimeLineType.month:
        // Para mês, não mostra indicador ou implementa lógica específica
        break;
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.timelineType == TimeLineType.week
        ? _buildWeekContent()
        : SingleChildScrollView(
            controller: _scrollController,
            child: _buildNormalContent(),
          );
  }
}

class _NowIndicator extends StatelessWidget {
  final DateTime time;
  final bool isColumnIndicator;
  final bool isDashed;
  static const double hourLabelWidth = 45;

  const _NowIndicator({
    required this.time,
    this.isColumnIndicator = false,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    final label =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    if (isColumnIndicator) {
      // Para indicadores de coluna, linha sólida ou pontilhada
      return isDashed
          ? CustomPaint(
              size: Size(double.infinity, 1.5),
              painter: _DashedLinePainter(),
            )
          : Container(height: 1.5, color: Colors.red);
    }

    return Row(
      children: [
        SizedBox(
          width: hourLabelWidth,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 2, color: Colors.red),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: isDashed
              ? CustomPaint(
                  size: Size(double.infinity, 1.5),
                  painter: _DashedLinePainter(),
                )
              : Container(height: 1.5, color: Colors.red),
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0.0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ClosedDayOverlay extends StatelessWidget {
  final bool isClosed;
  const _ClosedDayOverlay(this.isClosed);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isClosed ? Colors.grey.withValues(alpha: 0.1) : Colors.white,
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: isClosed
          ? CustomPaint(painter: _DiagonalLinesPainter(), child: Container())
          : Container(),
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

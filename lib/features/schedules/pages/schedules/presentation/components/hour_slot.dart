import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/home/presentation/components/add_options_modal.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';

class HourSlot extends StatefulWidget {
  final double pixelsPerMinute;
  final int hour;
  final SchedulesLoaded state;
  final bool showHours;

  // Constantes para melhor organização
  static const double hourLabelWidth = 45;
  static const double dateHeaderHeight = 40;
  static const double dividerWidth = 1;
  static const double separatorAlpha = 0.4;
  static const double timelineAlpha = 0.2;
  static const double weekColumnWidth =
      150; // Largura de cada coluna em modo week

  const HourSlot({
    super.key,
    required this.hour,
    required this.pixelsPerMinute,
    required this.state,
    this.showHours = true,
  });

  @override
  State<HourSlot> createState() => _HourSlotState();
}

class _HourSlotState extends State<HourSlot> {
  final Set<String> _selectedColumns = {};
  final Map<String, Timer> _selectionTimers = {};

  @override
  void dispose() {
    for (var timer in _selectionTimers.values) {
      timer.cancel();
    }
    _selectionTimers.clear();
    super.dispose();
  }

  String _getColumnKey(DateTime date, int minuteSection) {
    return '${widget.hour}_${date.day}_${date.month}_${date.year}_$minuteSection';
  }

  void _selectColumn(DateTime date, int minuteSection) {
    final columnKey = _getColumnKey(date, minuteSection);
    setState(() {
      _selectedColumns.add(columnKey);
    });

    // Cancelar timer anterior desta seção se existir
    _selectionTimers[columnKey]?.cancel();

    // Criar novo timer para esta seção específica
    _selectionTimers[columnKey] = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _selectedColumns.remove(columnKey);
        });
        _selectionTimers.remove(columnKey);
      }
    });
  }

  bool _isBusinessOpen(DateTime date) {
    final weekday = date.weekday;

    // Mapear weekday do DateTime para nome do dia usado no BusinessData
    final dayName = _getDayName(weekday);

    final openingHours = BusinessData.openingHours;
    if (openingHours.isEmpty) {
      return true; // Se não tem horários configurados, assume aberto
    }

    try {
      final todayHours = openingHours.firstWhere(
        (openingHour) => openingHour.day == dayName,
      );

      if (!todayHours.open) return false; // Dia fechado

      // Verificar se o horário atual está dentro do funcionamento
      final startHour = int.parse(todayHours.startAt.split(':')[0]);
      final endHour = int.parse(todayHours.endAt.split(':')[0]);

      return widget.hour >= startHour && widget.hour < endHour;
    } catch (e) {
      return true; // Se não encontrar o dia, assume aberto
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
        return 'Segunda-feira';
    }
  }

  void _onColumnTap(
    TapDownDetails details,
    DateTime date,
    BuildContext context,
  ) {
    // Calcular os minutos baseado na posição Y do clique
    final clickedMinutes = (details.localPosition.dy / widget.pixelsPerMinute)
        .round();

    // Calcular qual seção de 15 minutos foi clicada (0, 1, 2 ou 3)
    final minuteSection = (clickedMinutes / 15).floor();

    // Selecionar visualmente apenas a seção de 15 minutos
    _selectColumn(date, minuteSection);

    // Usar a seção clicada para determinar os minutos
    int roundedMinutes = minuteSection * 15;
    int finalHour = widget.hour;

    // Se os minutos arredondados chegarem a 60, adicionar 1 hora e zerar minutos
    if (roundedMinutes >= 60) {
      finalHour += (roundedMinutes ~/ 60);
      roundedMinutes = roundedMinutes % 60;
    }

    // Criar a data e hora exata com a seção clicada
    final clickedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      finalHour,
      roundedMinutes,
    );

    // Abrir o AddOptionsModal passando a data e hora clicada
    showAddressDataEditSheet(context: context, dateTime: clickedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60 * widget.pixelsPerMinute,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (widget.state.timelineType != TimeLineType.week)
          SizedBox(
            width: widget.showHours ? HourSlot.hourLabelWidth : 0,
            height: double.infinity,
            child: widget.showHours
                ? Container(
                    color: Colors.white,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        '${widget.hour.toString().padLeft(2, '0')}:00',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          ..._buildColumns(context),
        ],
      ),
    );
  }

  Widget _buildTimelineColumn(DateTime date, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _onColumnTap(details, date, context),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: _lines(date),
        ),
      ),
    );
  }

  Widget _buildWeekTimelineColumn(DateTime date, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => _onColumnTap(details, date, context),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.transparent,
          child: _lines(date),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: HourSlot.dividerWidth,
      color: Colors.grey.withValues(alpha: HourSlot.separatorAlpha),
    );
  }

  List<Widget> _buildColumns(BuildContext context) {
    switch (widget.state.timelineType) {
      case TimeLineType.day:
        return [_buildTimelineColumn(widget.state.date, context)];

      case TimeLineType.threeDays:
        return [
          _buildTimelineColumn(widget.state.date, context),
          _buildDivider(),
          _buildTimelineColumn(
            widget.state.date.add(const Duration(days: 1)),
            context,
          ),
          _buildDivider(),
          _buildTimelineColumn(
            widget.state.date.add(const Duration(days: 2)),
            context,
          ),
        ];

      case TimeLineType.week:
        final columns = <Widget>[];
        for (int i = 0; i < 7; i++) {
          if (i > 0) columns.add(_buildDivider());
          columns.add(
            _buildWeekTimelineColumn(
              widget.state.date.add(Duration(days: i)),
              context,
            ),
          );
        }
        return columns;
      case TimeLineType.month:
        return [];
    }
  }

  Widget _lines(DateTime date) {
    final isClosed = !_isBusinessOpen(date);

    return Stack(
      children: [
        // Criar 4 seções de 15 minutos
        for (int section = 0; section < 4; section++)
          _buildFifteenMinuteSection(date, section, isClosed),
      ],
    );
  }

  Widget _buildFifteenMinuteSection(DateTime date, int section, bool isClosed) {
    final sectionKey = _getColumnKey(date, section);
    final isSelected = _selectedColumns.contains(sectionKey);
    final topPosition = section * 15.0;
    final height = 15.0 * widget.pixelsPerMinute;

    return Positioned(
      top: topPosition * widget.pixelsPerMinute,
      left: 0,
      right: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
        child: Stack(
          children: [
            // Linha superior da seção
            if (section == 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  color: Colors.grey.withValues(alpha: HourSlot.separatorAlpha),
                ),
              ),
            // Linha inferior (sempre)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: section == 3
                    ? Colors.grey.withValues(alpha: HourSlot.separatorAlpha)
                    : Colors.grey.withValues(alpha: HourSlot.timelineAlpha),
              ),
            ),
            // Exibir data quando selecionado
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                child: Builder(
                  builder: (context) {
                    // Início da seção
                    int startMinutes = section * 15;
                    int startHour = widget.hour;
                    if (startMinutes >= 60) {
                      startHour += (startMinutes ~/ 60);
                      startMinutes = startMinutes % 60;
                    }

                    // Fim da seção
                    int endMinutes = (section + 1) * 15;
                    int endHour = widget.hour;
                    if (endMinutes >= 60) {
                      endHour += (endMinutes ~/ 60);
                      endMinutes = endMinutes % 60;
                    }

                    return Text(
                      '${startHour.toString().padLeft(2, '0')}:${startMinutes.toString().padLeft(2, '0')} - ${endHour.toString().padLeft(2, '0')}:${endMinutes.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            // Overlay de fechado
            if (isClosed)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.grey.withValues(alpha: 0.05),
                  child: CustomPaint(painter: _DiagonalLinesPainter()),
                ),
              ),
          ],
        ),
      ),
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

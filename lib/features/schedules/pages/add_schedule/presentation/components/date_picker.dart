import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showAddScheduleTimeSheet({
  required BuildContext bcontext,
  required AddScheduleLoaded state,
}) async {
  await showModalBottomSheet(
    context: bcontext,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.black26,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return Container(
        height: MediaQuery.of(bcontext).size.height * 0.9,
        color: Colors.white,
        child: _TimelineCalendarModal(state: state, bcontext: bcontext),
      );
    },
  );
}

class _TimelineCalendarModal extends StatefulWidget {
  const _TimelineCalendarModal({required this.state, required this.bcontext});

  final AddScheduleLoaded state;
  final BuildContext bcontext;

  @override
  State<_TimelineCalendarModal> createState() => _TimelineCalendarModalState();
}

class _TimelineCalendarModalState extends State<_TimelineCalendarModal> {
  final ScrollController _controller = ScrollController();
  late List<DateTime> months;

  @override
  void initState() {
    super.initState();
    
    final selectedDate = widget.state.date;
    final today = DateTime.now();
    
    // Criar lista de meses centrada na data selecionada
    // 3 meses antes da data selecionada até 8 meses depois (total de 12 meses)
    months = [];
    final startMonth = DateTime(selectedDate.year, selectedDate.month - 3, 1);
    
    for (int i = 0; i < 12; i++) {
      final month = DateTime(startMonth.year, startMonth.month + i, 1);
      // Só adicionar meses que não sejam anteriores ao mês atual
      if (month.isAfter(DateTime(today.year, today.month - 1, 1))) {
        months.add(month);
      }
    }
    
    // Se não há meses suficientes (por causa da filtragem), adicionar mais meses futuros
    if (months.length < 12) {
      final lastMonth = months.isNotEmpty ? months.last : DateTime(today.year, today.month, 1);
      while (months.length < 12) {
        final nextMonth = DateTime(lastMonth.year, lastMonth.month + months.length, 1);
        months.add(nextMonth);
      }
    }

    // Posicionar o scroll para que o mês da data selecionada fique no topo/centro
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnSelectedDate();
    });
  }

  void _centerOnSelectedDate() {
    final selectedDate = widget.state.date;
    
    // Encontrar o índice do mês da data selecionada
    final selectedMonthIndex = months.indexWhere((month) =>
        month.year == selectedDate.year && month.month == selectedDate.month);
    
    if (selectedMonthIndex != -1 && _controller.hasClients) {
      // Calcular posição para centralizar (aproximadamente 300px por mês)
      final scrollPosition = selectedMonthIndex * 300.0;
      
      _controller.jumpTo(scrollPosition.clamp(0.0, _controller.position.maxScrollExtent));
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Align(
              alignment: AlignmentGeometry.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(LucideIcons.x300, color: Colors.black87),
              ),
            ),
          ),
          
          // Calendar
          Expanded(
            child: SingleChildScrollView(
              controller: _controller,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: months.map((month) => _buildMonthCalendar(month)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    final monthName = _getMonthName(month.month);
    final year = month.year;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título do mês
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '$monthName $year',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          // Dias da semana
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'].map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          // Calendário do mês
          _buildMonthGrid(month),
        ],
      ),
    );
  }

  Widget _buildMonthGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // 0 = domingo
    
    final weeks = <Widget>[];
    var dayCounter = 1;
    
    // Calcular número de semanas necessárias
    final totalCells = startWeekday + daysInMonth;
    final numberOfWeeks = (totalCells / 7).ceil();
    
    for (int week = 0; week < numberOfWeeks; week++) {
      final weekDays = <Widget>[];
      
      for (int day = 0; day < 7; day++) {
        final cellIndex = week * 7 + day;
        
        if (cellIndex < startWeekday || dayCounter > daysInMonth) {
          weekDays.add(const Expanded(child: SizedBox(height: 40)));
        } else {
          final currentDay = DateTime(month.year, month.month, dayCounter);
          final today = DateTime.now();
          final isToday = _isSameDay(currentDay, today);
          final isSelected = _isSameDay(currentDay, widget.state.date);
          final isPastDate = currentDay.isBefore(DateTime(today.year, today.month, today.day));
          
          weekDays.add(
            Expanded(
              child: GestureDetector(
                onTap: isPastDate ? null : () {
                  widget.bcontext.read<AddScheduleBloc>().add(SelectDate(date: currentDay));
                  Navigator.of(context).pop(currentDay);
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : isToday
                            ? AppColors.secondary.withValues(alpha: 0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Opacity(
                          opacity: isPastDate ? 0.3 : 1.0,
                          child: Text(
                            dayCounter.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isToday ? FontWeight.w400 : FontWeight.normal,
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? AppColors.secondary
                                      : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      if (isPastDate)
                        Center(
                          child: Container(
                            width: 12,
                            height: 1,
                            color: Colors.black12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      
      weeks.add(Row(children: weekDays));
    }
    
    return Column(children: weeks);
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  String _getMonthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
  }
}


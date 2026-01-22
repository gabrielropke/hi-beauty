// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';
import 'package:hibeauty/theme/app_colors.dart';

Future<void> showTimelineCalendarSheet({
  required BuildContext bcontext,
  required SchedulesLoaded state,
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

  final SchedulesLoaded state;
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
    
    // Criar lista de 13 meses (6 para trás, atual, 6 para frente)
    months = [];
    final selectedDate = widget.state.date;
    for (int i = -6; i <= 6; i++) {
      final month = DateTime(selectedDate.year, selectedDate.month + i, 1);
      months.add(month);
    }

    // Scroll para o mês da data selecionada após o build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentMonth();
    });
  }

  void _scrollToCurrentMonth() {
    if (_controller.hasClients) {
      final selectedDate = widget.state.date;
      final currentMonthIndex = months.indexWhere((month) =>
          month.year == selectedDate.year && month.month == selectedDate.month);
      
      if (currentMonthIndex != -1) {
        // Calcular posição aproximada (altura de cada mês ~300px)
        // Subtrair um pouco para centralizar mais para cima
        final position = (currentMonthIndex * 300.0) + 150;
        _controller.jumpTo(
          position.clamp(0, _controller.position.maxScrollExtent)
        );
      }
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Align(
                alignment: AlignmentGeometry.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.black87),
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
          final isToday = _isSameDay(currentDay, DateTime.now());
          final isSelected = _isSameDay(currentDay, widget.state.date);
          
          weekDays.add(
            Expanded(
              child: GestureDetector(
                onTap: () {
                  widget.bcontext.read<SchedulesBloc>().add(SelectDate(date: currentDay));
                  // Aqui você pode adicionar lógica para retornar a data selecionada
                  Navigator.of(context).pop(currentDay);
                },
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.secondary
                        : isToday
                            ? AppColors.secondary.withOpacity(0.1)
                            : Colors.transparent,
                        shape: BoxShape.circle
                  ),
                  child: Center(
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


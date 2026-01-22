
import 'package:flutter/material.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:lucide_icons_flutter/lucide_icons.dart';

class BarSalesGraphic extends StatelessWidget {
  final DashboardLoaded state;
  const BarSalesGraphic({super.key, required this.state});

  String _formatDateLabel(DateTime date) {
    final data = state.data!;
    final period = data.period;
    
    if (period == '7') {
      // Para 7 dias: mostrar dd/mm
      return DateFormat('dd/MM', 'pt_BR').format(date);
    } else if (period == '30') {
      // Para 30 dias: mostrar semana (ex: "Sem 1", "Sem 2")
      final startOfYear = DateTime(date.year, 1, 1);
      final weekNumber = ((date.difference(startOfYear).inDays) ~/ 7) + 1;
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      return 'Sem $weekNumber\n${DateFormat('dd/MM', 'pt_BR').format(weekStart)}';
    } else {
      // Para 90 dias: mostrar mês
      return DateFormat('MMM\nyyyy', 'pt_BR').format(date);
    }
  }

  List<ChartDataPoint> _buildChartDataFromAppointments() {
    final data = state.data!;
    final period = data.period;

    final Map<DateTime, double> totalByDay = {};

    for (final transaction in data.recentTransactions) {
      if (transaction.status != 'PAID') continue;

      final rawDate = transaction.serviceDate ?? transaction.dueDate;
      if (rawDate == null) continue;

      // 🔑 Converter para local e normalizar o dia
      final localDate = rawDate.toLocal();
      final dayKey = DateTime(localDate.year, localDate.month, localDate.day);

      totalByDay[dayKey] = (totalByDay[dayKey] ?? 0) + transaction.amount;
    }

    // MOCK
    // for (final transaction in mockData) {
    //   if (transaction["status"] != "PAID") continue;

    //   final rawDate = DateTime.parse(transaction["serviceDate"]);
    //   final localDate = rawDate.toLocal();

    //   final dayKey = DateTime(localDate.year, localDate.month, localDate.day);

    //   totalByDay[dayKey] = (totalByDay[dayKey] ?? 0) + transaction["amount"];
    // }

    // Agrupar dados baseado no período
    if (period == '7') {
      // Para 7 dias: manter agrupamento por dia
      final points =
          totalByDay.entries
              .map(
                (entry) => ChartDataPoint(
                  date: entry.key.toIso8601String(),
                  dateLabel: _formatDateLabel(entry.key),
                  value: entry.value,
                ),
              )
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));

      return points;
    } else if (period == '30') {
      // Para 30 dias: agrupar por semana
      final Map<String, double> weeklyTotals = {};
      final Map<String, DateTime> weekDates = {};

      totalByDay.forEach((date, amount) {
        final weekStart = date.subtract(Duration(days: date.weekday - 1));
        final weekKey = DateFormat('yyyy-MM-dd').format(weekStart);
        
        weeklyTotals[weekKey] = (weeklyTotals[weekKey] ?? 0) + amount;
        weekDates[weekKey] = weekStart;
      });

      final points = weeklyTotals.entries
          .map((entry) => ChartDataPoint(
                date: entry.key,
                dateLabel: _formatDateLabel(weekDates[entry.key]!),
                value: entry.value,
              ))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      return points;
    } else {
      // Para 90 dias: agrupar por mês  
      final Map<String, double> monthlyTotals = {};
      final Map<String, DateTime> monthDates = {};

      totalByDay.forEach((date, amount) {
        final monthStart = DateTime(date.year, date.month, 1);
        final monthKey = DateFormat('yyyy-MM').format(monthStart);
        
        monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0) + amount;
        monthDates[monthKey] = monthStart;
      });

      final points = monthlyTotals.entries
          .map((entry) => ChartDataPoint(
                date: entry.key,
                dateLabel: _formatDateLabel(monthDates[entry.key]!),
                value: entry.value,
              ))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      return points;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _buildChartDataFromAppointments();

    if (chartData.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.chartNetwork300,
                    size: 40,
                    color: Colors.black87,
                  ),
                  Text(
                    'Seus pagamentos serão exibidos aqui, em formato de gráfico de barras!',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final maxValue = chartData.isEmpty
        ? 0.0
        : chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    // Arredondar para múltiplos de 50
    double adjustedMaxValue;
    if (maxValue == 0) {
      adjustedMaxValue = 50.0;
    } else {
      adjustedMaxValue = ((maxValue / 50).ceil() * 50).toDouble();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        height: 350,
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
              Text(
                'Pagamentos recebidos',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 14),
              Expanded(
                child: CustomPaint(
                  size: Size.infinite,
                  painter: BarChartPainter(
                    data: chartData,
                    maxValue: adjustedMaxValue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartDataPoint {
  final String date;
  final String dateLabel;
  final double value;

  ChartDataPoint({
    required this.date,
    required this.dateLabel,
    required this.value,
  });
}

class BarChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;
  final double maxValue;

  BarChartPainter({required this.data, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Configuração de cores e gradientes
    final primaryColor = Colors.blueAccent;
    final secondaryColor = Colors.blueAccent; // Light indigo

    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1.0;

    final textPainter = TextPainter(
      text: TextSpan(text: ''),
      textDirection: ui.TextDirection.ltr,
    );

    // Margens
    const leftMargin = 60.0;
    const bottomMargin = 50.0;
    const topMargin = 20.0;
    const rightMargin = 10.0;

    final chartWidth = size.width - leftMargin - rightMargin;
    final chartHeight = size.height - topMargin - bottomMargin;

    // Desenhar linhas de grade horizontais e valores do eixo Y
    final ySteps = 5;
    for (int i = 0; i <= ySteps; i++) {
      final y = topMargin + (chartHeight * i / ySteps);
      final value = maxValue * (ySteps - i) / ySteps;

      // Linha de grade horizontal
      canvas.drawLine(
        Offset(leftMargin, y),
        Offset(leftMargin + chartWidth, y),
        gridPaint,
      );

      // Valor no eixo Y
      textPainter.text = TextSpan(
        text: NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$',
          decimalDigits: 0,
        ).format(value),
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftMargin - textPainter.width - 8, y - textPainter.height / 2),
      );
    }

    // Calcular largura das barras
    final barSpacing =
        chartWidth * 0.1 / data.length; // Espaçamento proporcional
    final availableWidth = chartWidth - (barSpacing * (data.length + 1));
    final barWidth = (availableWidth / data.length).clamp(20.0, 60.0);

    // Desenhar barras
    for (int i = 0; i < data.length; i++) {
      final barHeight = (chartHeight * data[i].value / maxValue);
      final x = leftMargin + barSpacing + (i * (barWidth + barSpacing));
      final y = topMargin + chartHeight - barHeight;

      // Criar gradiente para a barra
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [primaryColor, secondaryColor],
      );

      // Rect da barra
      final barRect = Rect.fromLTWH(x, y, barWidth, barHeight);

      // Paint com gradiente
      final barPaint = Paint()
        ..shader = gradient.createShader(barRect)
        ..style = PaintingStyle.fill;

      // Desenhar barra com cantos arredondados
      final borderRadius = Radius.circular(6.0);
      final rrect = RRect.fromRectAndCorners(
        barRect,
        topLeft: borderRadius,
        topRight: borderRadius,
      );

      canvas.drawRRect(rrect, barPaint);

      // Sombra sutil na base da barra
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.1)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

      final shadowRect = Rect.fromLTWH(
        x + 1,
        y + barHeight - 1,
        barWidth - 2,
        3,
      );
      canvas.drawRect(shadowRect, shadowPaint);

      // Label da data no eixo X (rotacionado)
      textPainter.text = TextSpan(
        text: data[i].dateLabel,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();

      final labelX = x + (barWidth / 2);
      final labelY = topMargin + chartHeight + 12;

      canvas.save();

      // Move o canvas para o ponto do texto
      canvas.translate(labelX, labelY);

      // Rotaciona -45 graus
      canvas.rotate(-0.885398); // -45° em radianos

      // Desenha o texto
      textPainter.paint(canvas, Offset(-textPainter.width / 1, 0));

      canvas.restore();

      // Se não há espaço na barra, mostrar acima
      textPainter.text = TextSpan(
        text: NumberFormat.currency(
          locale: 'pt_BR',
          symbol: 'R\$',
          decimalDigits: 0,
        ).format(data[i].value),
        style: TextStyle(
          color: primaryColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();

      final valueX = x + (barWidth / 2) - (textPainter.width / 2);
      final valueY = y - textPainter.height - 4;

      textPainter.paint(canvas, Offset(valueX, valueY));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// MOCK PRA SIMULAR DIAS
// List<Map<String, dynamic>> generateMockTransactions30Days(
//   DashboardLoaded state,
// ) {
//   final now = DateTime.now();
//   final random = Random();

//   final List<Map<String, dynamic>> transactions = [];

//   for (
//     int day = 0;
//     day <
//         (state.periodKey == DashboardPeriod.week
//             ? 7
//             : state.periodKey == DashboardPeriod.month
//             ? 30
//             : 90);
//     day++
//   ) {
//     final baseDate = now.subtract(Duration(days: day));

//     final transactionsPerDay = random.nextInt(4) + 1; // 1 a 4 atendimentos

//     for (int i = 0; i < transactionsPerDay; i++) {
//       final amountOptions = [30, 60, 90, 120, 150, 180, 210];
//       final amount = amountOptions[random.nextInt(amountOptions.length)];

//       transactions.add({
//         "id": "mock_${day}_$i",
//         "amount": amount,
//         "status": "PAID",
//         "serviceDate": DateTime(
//           baseDate.year,
//           baseDate.month,
//           baseDate.day,
//           random.nextInt(10) + 9, // horário comercial
//           random.nextInt(60),
//         ).toUtc().toIso8601String(),
//       });
//     }
//   }

//   return transactions;
// }

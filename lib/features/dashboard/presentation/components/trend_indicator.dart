import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TrendIndicator extends StatelessWidget {
  final String trend;
  final String change;

  const TrendIndicator({super.key, required this.trend, required this.change});

  @override
  Widget build(BuildContext context) {
    final isUpTrend = trend == 'up';
    final color = isUpTrend ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isUpTrend ? LucideIcons.arrowUp : LucideIcons.arrowDown,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            change,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

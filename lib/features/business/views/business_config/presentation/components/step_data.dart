import 'package:flutter/material.dart';

class StepData {
  final int number;
  final String title;
  final String subtitle;
  final bool completed;
  final IconData icon;
  final String route;
  const StepData({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.icon,
    required this.route,
  });
}

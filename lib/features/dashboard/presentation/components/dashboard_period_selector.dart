import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:hibeauty/features/dashboard/presentation/components/top_resume_dashboard.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DashboardPeriodSelector extends StatelessWidget {
  final DashboardLoaded state;

  const DashboardPeriodSelector({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
        mainAxisSize: MainAxisSize.min,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        height: 30,
        label: _getPeriodLabel(),
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        borderColor: Colors.black12,
        spacing: 8,
        suffixIcon: const Icon(LucideIcons.pencil, size: 16),
        function: () =>
            showPeriodDashboardEditSheet(context: context, state: state),
      ),
    );
  }

  String _getPeriodLabel() {
    return switch (state.periodKey) {
      DashboardPeriod.week => 'Últimos 7 dias',
      DashboardPeriod.month => 'Últimos 30 dias',
      DashboardPeriod.quarter => 'Últimos 90 dias',
    };
  }
}

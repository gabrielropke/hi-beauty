import 'package:flutter/material.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:hibeauty/features/dashboard/presentation/components/item_dashboard.dart';
import 'package:hibeauty/features/dashboard/presentation/components/trend_indicator.dart';

class DashboardInsightsRow extends StatelessWidget {
  final DashboardLoaded state;

  const DashboardInsightsRow({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(child: _ClientsInsight(state: state)),
          const SizedBox(width: 12),
          Expanded(child: _RevenueInsight(state: state)),
        ],
      ),
    );
  }
}

class _ClientsInsight extends StatelessWidget {
  final DashboardLoaded state;

  const _ClientsInsight({required this.state});

  @override
  Widget build(BuildContext context) {
    final activeClients = state.data?.insights.activeClients;

    if (activeClients == null) return const SizedBox.shrink();

    return ItemDashboard(
      state: state,
      title: 'Clientes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${activeClients.total}',
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          TrendIndicator(
            trend: activeClients.trend,
            change: activeClients.change,
          ),
        ],
      ),
    );
  }
}


class _RevenueInsight extends StatelessWidget {
  final DashboardLoaded state;

  const _RevenueInsight({required this.state});

  @override
  Widget build(BuildContext context) {
    final revenue = state.data?.insights.revenue;

    if (revenue == null) return const SizedBox.shrink();

    return ItemDashboard(
      state: state,
      title: 'Faturamento',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(moneyFormat(context, revenue.total.toString()), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          TrendIndicator(trend: revenue.trend, change: revenue.change),
        ],
      ),
    );
  }
}

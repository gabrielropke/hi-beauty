import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TopDashboardResume extends StatelessWidget {
  final DashboardLoaded state;
  const TopDashboardResume({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final data = state.data!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agendamentos recentes',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () => showPeriodDashboardEditSheet(context: context, state: state),
                    child: Container(
                      width: 30,
                      height: 35,
                      color: Colors.transparent,
                      child: Icon(LucideIcons.ellipsisVertical300),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2),
              Text(
                data.period == '1'
                    ? 'Ontem'
                    : 'Últimos ${data.period} ${int.parse(data.period) == 1 ? 'dia' : 'dias'}',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Total de atendimentos ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: '${data.insights.appointments.total}',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text(
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                        data.insights.reviews.averageRating == 0
                          ? '0'
                          : data.insights.reviews.change),
                      Container(
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.orange, width: 0.5)
                        ),
                        child: Center(
                          child: Icon(LucideIcons.star300, color: Colors.orange, size: 18,),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

////////////
/// MODAL DE PERIDO ///
////////////

Future<void> showPeriodDashboardEditSheet({
  required BuildContext context,
  required DashboardLoaded state,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) => BlocProvider.value(
      value: context.read<DashboardBloc>(),
      child: _ModalPeriodView(state: state, bcontext: context),
    ),
  );
}

class _ModalPeriodView extends StatefulWidget {
  final BuildContext bcontext;
  final DashboardLoaded state;
  const _ModalPeriodView({required this.state, required this.bcontext});

  @override
  State<_ModalPeriodView> createState() => _ModalPeriodViewState();
}

class _ModalPeriodViewState extends State<_ModalPeriodView> {
  late String _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _selectedPeriod = widget.state.data?.period == '7'
        ? 'week'
        : widget.state.data?.period == '30'
        ? 'month'
        : 'quarter';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Período de exibição',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 32),
                      AppDropdown(
                        title: 'Período',
                        items: [
                          {'label': 'Últimos 7 dias', 'value': 'week'},
                          {'label': 'Últimos 30 dias', 'value': 'month'},
                          {'label': 'Últimos 90 dias', 'value': 'quarter'},
                        ],
                        labelKey: 'label',
                        valueKey: 'value',
                        selectedValue: _selectedPeriod,
                        placeholder: Text(
                          _selectedPeriod == 'week'
                              ? 'Últimos 7 dias'
                              : _selectedPeriod == 'month'
                              ? 'Últimos 30 dias'
                              : 'Últimos 90 dias',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        onChanged: (v) =>
                            setState(() => _selectedPeriod = v as String),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final loading = (state is DashboardLoaded) ? state.loading : false;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: AppButton(
                label: 'Aplicar alterações',
                loading: loading,
                function: () {
                  final period = _selectedPeriod == 'week'
                      ? DashboardPeriod.week
                      : _selectedPeriod == 'month'
                      ? DashboardPeriod.month
                      : DashboardPeriod.quarter;
                  widget.bcontext.read<DashboardBloc>().add(
                    UpdatePeriodDashboard(periodKey: period),
                  );
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

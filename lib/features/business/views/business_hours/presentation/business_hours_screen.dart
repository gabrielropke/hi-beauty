import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/features/business/views/business_hours/presentation/bloc/business_hours_bloc.dart';
import 'package:hibeauty/features/business/views/business_hours/presentation/components/business_hours_tabs.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class BusinessHoursScreen extends StatelessWidget {
  const BusinessHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          BusinessHoursBloc(context)..add(BusinessHoursLoadRequested()),
      child: const BusinessHoursView(),
    );
  }
}

class BusinessHoursView extends StatefulWidget {
  const BusinessHoursView({super.key});

  @override
  State<BusinessHoursView> createState() => _BusinessHoursViewState();
}

class _BusinessHoursViewState extends State<BusinessHoursView> {
  final ScrollController _scrollController = ScrollController();
  int _currentTab = 0; // rastrear aba ativa

  Future<void> _refresh() async {
    final bloc = context.read<BusinessHoursBloc>();
    final completer = Completer<void>();
    late final StreamSubscription sub;
    sub = bloc.stream.listen((s) {
      if (s is BusinessHoursLoaded && !completer.isCompleted) {
        completer.complete();
      }
    });
    bloc.add(BusinessHoursLoadRequested());
    await completer.future.timeout(
      const Duration(seconds: 10),
      onTimeout: () {},
    );
    await sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BlocBuilder<BusinessHoursBloc, BusinessHoursState>(
        builder: (context, state) => switch (state) {
          BusinessHoursLoading _ => const AppLoader(),
          BusinessHoursLoaded s => _loaded(s, l10n),
          BusinessHoursState() => const AppLoader(),
        },
      ),
    );
  }

  Widget _loaded(BusinessHoursLoaded state, AppLocalizations l10n) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              title: l10n.scheduledShifts,
              controller: _scrollController,
              backgroundColor: Colors.white,
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.black87,
                backgroundColor: Colors.white,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Text(
                        l10n.scheduledShifts,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        l10n.businessHoursDescription,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      BusinessHoursTabs(
                        teamMembers: state.teamMembers,
                        initialWorkingHours: (state.openingHours),
                        onBusinessHoursChanged: (hours) {
                          context.read<BusinessHoursBloc>().add(
                            SetLocalUpdateHours(hours),
                          );
                        },
                        onTabChanged: (i) => setState(() => _currentTab = i),
                      ),
                      if (_currentTab == 0)
                        const SizedBox(height: 80) // reserva espaço para botão
                      else
                        const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _currentTab == 0
            ? SafeArea(
                top: false,
                child: BlocBuilder<BusinessHoursBloc, BusinessHoursState>(
                  builder: (context, state) {
                    final loading = state is BusinessHoursLoaded
                        ? state.loading
                        : false;
                    final canSave =
                        state is BusinessHoursLoaded &&
                        (state.openingHours.isNotEmpty);
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
                        label: l10n.save,
                        loading: loading,
                        function: canSave
                            ? () {
                                final s = context
                                    .read<BusinessHoursBloc>()
                                    .state;
                                if (s is BusinessHoursLoaded) {
                                  context.read<BusinessHoursBloc>().add(
                                    BusinessHoursSave(s.openingHours),
                                  );
                                }
                              }
                            : null,
                      ),
                    );
                  },
                ),
              )
            : null,
      ),
    );
  }
}

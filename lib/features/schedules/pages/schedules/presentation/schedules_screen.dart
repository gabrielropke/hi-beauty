import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/constants/global_top_infos.dart';
import 'package:hibeauty/features/schedules/data/model.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/calendar.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/team_week_view.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/timeline.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/components/top.dart';
import 'package:hibeauty/l10n/app_localizations.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SchedulesBloc(context)..add(SchedulesLoadRequested()),
      child: const SchedulesView(),
    );
  }
}

class SchedulesView extends StatefulWidget {
  const SchedulesView({super.key});

  @override
  State<SchedulesView> createState() => _SchedulesViewState();
}

class _SchedulesViewState extends State<SchedulesView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isShowingPopup = false;
  Timer? _popupCheckTimer;

  @override
  void initState() {
    super.initState();
    _updatePopupState();
    _startPopupStateChecker();
  }

  @override
  void dispose() {
    _popupCheckTimer?.cancel();
    super.dispose();
  }

  void _updatePopupState() {
    final newState = shouldShowSignature() || shouldShowCompleteBusinessData();
    if (_isShowingPopup != newState) {
      setState(() {
        _isShowingPopup = newState;
      });
    }
  }

  void _startPopupStateChecker() {
    _popupCheckTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      if (mounted) {
        _updatePopupState();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SchedulesBloc, SchedulesState>(
      builder: (blocContext, state) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: switch (state) {
            SchedulesLoading _ => const AppLoader(),
            SchedulesLoaded s => _loaded(s, context, l10n, _scaffoldKey),
            SchedulesState() => const AppLoader(),
          },
        );
      },
    );
  }

  Widget _loaded(
    SchedulesLoaded state,
    BuildContext context,
    AppLocalizations l10n,
    GlobalKey<ScaffoldState> scaffoldKey,
  ) {
    // Extrair bookings baseado no tipo de timeline
    List<BookingModel> bookings = [];

    if (state.timelineType == TimeLineType.day) {
      bookings = state.booking ?? [];
    } else if (state.bookingWeekOrMonth != null) {
      // Para visualizações semanais/mensais, extrair todos os bookings de todos os dias
      for (final dayData in state.bookingWeekOrMonth!.bookingsByDay) {
        bookings.addAll(dayData.bookings);
      }
    }

    final isShowingPopup = _isShowingPopup;
    
    return SafeArea(
      top: !isShowingPopup,
      bottom: false,
      child: BlocBuilder<SchedulesBloc, SchedulesState>(
        builder: (schedulesContext, schedulesState) {
          if (schedulesState is SchedulesLoaded) {
            return Column(
              children: [
                exibitionTopPopup(context),
                TimelineTop(state: schedulesState, bcontext: schedulesContext),
                if (state.timelineType == TimeLineType.week) ...[
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: const Color.fromARGB(255, 12, 12, 12).withAlpha(100),
                  ),
                  TeamWeekView(state: schedulesState),
                ] else if (state.timelineType == TimeLineType.month)
                  CalendarSchedules(state: schedulesState)
                else ...[
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey.withAlpha(100),
                  ),
                  Expanded(
                    child: TimelineCalendar(
                      bookings: bookings,
                      state: schedulesState,
                    ),
                  ),
                ],
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

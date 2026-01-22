import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hibeauty/core/constants/global_top_infos.dart';
import 'package:hibeauty/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:hibeauty/features/dashboard/presentation/components/dashboard_period_selector.dart';
import 'package:hibeauty/features/dashboard/presentation/components/fast_actions.dart';
import 'package:hibeauty/features/dashboard/presentation/components/line_sales_graphic.dart';
import 'package:hibeauty/features/dashboard/presentation/components/next_appointments.dart';
import 'package:hibeauty/features/dashboard/presentation/components/top_resume_dashboard.dart';
import 'package:hibeauty/features/dashboard/presentation/components/dashboard_insights_row.dart';
import 'package:hibeauty/features/home/presentation/components/top.dart';

class DashboardContent extends StatefulWidget {
  final DashboardLoaded state;

  const DashboardContent({super.key, required this.state});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  bool _isShowingPopup = false;
  Timer? _popupCheckTimer;

  void _listen() {
    final controller = _scrollController;
    if (!controller.hasClients) return;

    final shouldShow = controller.offset > 30; // threshold value
    if (shouldShow != _showTitle) {
      setState(() => _showTitle = shouldShow);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listen);
    _updatePopupState();
    _startPopupStateChecker();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_listen);
    _scrollController.dispose();
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
    // SafeArea.top deve ser true apenas quando NÃO estiver exibindo popup
    final isShowingPopup = _isShowingPopup;

    return SafeArea(
      top: !isShowingPopup,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Popup sempre no topo, fora do scroll
          if (isShowingPopup) exibitionTopPopup(context),
          // Header fixo
          _buildHeader(),
          // Conteúdo scrollável
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Se não há popup, inclua o exibitionTopPopup no scroll
                  if (!isShowingPopup) exibitionTopPopup(context),
                  FastActions(state: widget.state),
                  DashboardPeriodSelector(state: widget.state),
                  BarSalesGraphic(state: widget.state),
                  SizedBox(height: 16),
                  TopDashboardResume(state: widget.state),
                  SizedBox(height: 16),
                  DashboardInsightsRow(state: widget.state),
                  SizedBox(height: 16),
                  NextAppointments(state: widget.state),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: HomeTop(businessInfoView: true),
        ),
        if (_showTitle)
          Container(
            color: Colors.black.withValues(alpha: 0.08),
            width: double.infinity,
            height: 1,
          ),
      ],
    );
  }
}

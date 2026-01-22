import 'package:flutter/material.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:hibeauty/features/business/views/business_hours/presentation/components/hours_selector.dart';
import 'package:hibeauty/features/business/views/business_hours/presentation/components/weekly_schedule_list.dart';
import 'package:hibeauty/features/onboarding/data/business/model.dart'; // OpeningHour
import 'package:hibeauty/theme/app_colors.dart';

class BusinessHoursTabs extends StatelessWidget {
  final List<TeamMemberModel> teamMembers;
  final List<OpeningHour> initialWorkingHours; // alterado
  final ValueChanged<List<OpeningHour>> onBusinessHoursChanged; // alterado
  final ValueChanged<int>? onTabChanged;

  const BusinessHoursTabs({
    super.key,
    required this.teamMembers,
    required this.initialWorkingHours,
    required this.onBusinessHoursChanged,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: _DynamicTabs(
        teamMembers: teamMembers,
        initialWorkingHours: initialWorkingHours,
        onBusinessHoursChanged: onBusinessHoursChanged,
        onTabChanged: onTabChanged,
      ),
    );
  }
}

class _DynamicTabs extends StatefulWidget {
  final List<TeamMemberModel> teamMembers;
  final List<OpeningHour> initialWorkingHours; // alterado
  final ValueChanged<List<OpeningHour>> onBusinessHoursChanged; // alterado
  final ValueChanged<int>? onTabChanged;

  const _DynamicTabs({
    required this.teamMembers,
    required this.initialWorkingHours,
    required this.onBusinessHoursChanged,
    this.onTabChanged,
  });

  @override
  State<_DynamicTabs> createState() => _DynamicTabsState();
}

class _DynamicTabsState extends State<_DynamicTabs>
    with TickerProviderStateMixin {
  late final TabController _tabCtrl;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() {
      if (_index != _tabCtrl.index && mounted) {
        setState(() => _index = _tabCtrl.index);
        widget.onTabChanged?.call(_tabCtrl.index);
      }
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _toMapList(List<OpeningHour> list) {
    return list
        .map((e) => {
              'day': e.day,
              'startAt': e.startAt,
              'endAt': e.endAt,
              'open': e.open,
            })
        .toList();
  }

  OpeningHour _fromMap(Map<String, dynamic> m) => OpeningHour(
        day: m['day'] as String? ?? '',
        startAt: m['startAt'] as String? ?? '',
        endAt: m['endAt'] as String? ?? '',
        open: m['open'] as bool? ?? false,
      );

  @override
  Widget build(BuildContext context) {
    final businessTab = HoursSelector(
      initialWorkingHours: _toMapList(widget.initialWorkingHours),
      onChanged: (maps) {
        final updated = maps.map(_fromMap).toList();
        widget.onBusinessHoursChanged(updated);
      },
    );
    final teamTab = WeeklyScheduleList(teamMembers: widget.teamMembers);

    final currentChild = _index == 0 ? businessTab : teamTab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StyledTabBar(controller: _tabCtrl),
        const SizedBox(height: 12),
        KeyedSubtree(
          key: ValueKey(_index),
          child: currentChild,
        ),
      ],
    );
  }
}

class _StyledTabBar extends StatelessWidget {
  final TabController? controller;
  const _StyledTabBar({this.controller});

  @override
  Widget build(BuildContext context) {
    final baseBorderColor = Colors.black.withValues(alpha: 0.14);
    final indicatorFill = AppColors.primary;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: baseBorderColor, width: 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: TabBar(
        controller: controller,
        splashBorderRadius: BorderRadius.circular(32),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black54,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: BoxDecoration(
          color: indicatorFill,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: baseBorderColor, width: 1),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Negócio'),
          Tab(text: 'Equipe'),
        ],
      ),
    );
  }
}

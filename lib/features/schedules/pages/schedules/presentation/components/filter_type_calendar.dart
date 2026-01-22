import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/schedules/pages/schedules/presentation/bloc/schedules_bloc.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FilterTypeCalendar extends StatefulWidget {
  final BuildContext bcontext;
  final SchedulesLoaded state;
  const FilterTypeCalendar({
    super.key,
    required this.bcontext,
    required this.state,
  });

  @override
  State<FilterTypeCalendar> createState() => _FilterTypeCalendarState();
}

class _FilterTypeCalendarState extends State<FilterTypeCalendar> {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CalendarHeader(showTitle: _showHeaderTitle),
                    Expanded(child: _CalendarContent(controller: _controller, bcontext: widget.bcontext, timelineType: widget.state.timelineType)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  final bool showTitle;

  const _CalendarHeader({required this.showTitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(child: _AnimatedHeaderTitle(showTitle: showTitle)),
        _CloseButton(),
      ],
    );
  }
}

class _AnimatedHeaderTitle extends StatelessWidget {
  final bool showTitle;

  const _AnimatedHeaderTitle({required this.showTitle});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      opacity: showTitle ? 1 : 0,
      child: IgnorePointer(
        ignoring: !showTitle,
        child: const Text(
          'Visualização do calendário',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(LucideIcons.x300),
        splashRadius: 20,
      ),
    );
  }
}

class _CalendarContent extends StatelessWidget {
  final ScrollController controller;
  final BuildContext bcontext;
  final TimeLineType timelineType;

  const _CalendarContent({required this.controller, required this.bcontext, required this.timelineType});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: [
        _CalendarMainTitle(),
        const SizedBox(height: 32),
        _CalendarViews(bcontext, timelineType),
      ],
    );
  }
}

class _CalendarMainTitle extends StatelessWidget {
  const _CalendarMainTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Visualização do calendário',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }
}

class _CalendarViews extends StatelessWidget {
  final BuildContext bcontext;
  final TimeLineType timelineType;
  const _CalendarViews(this.bcontext, this.timelineType);

  @override
  Widget build(BuildContext context) {
    final options = [
      _ViewOption(
        icon: LucideIcons.laptopMinimal300,
        title: 'Dia',
        isSelected: timelineType == TimeLineType.day,
        timeLineType: TimeLineType.day,
        bcontext: bcontext,
      ),
      _ViewOption(
        icon: LucideIcons.columns3300,
        title: '3 dias',
        isSelected: timelineType == TimeLineType.threeDays,
        timeLineType: TimeLineType.threeDays,
        bcontext: bcontext,
      ),
      _ViewOption(
        icon: LucideIcons.columns4300,
        title: 'Semana',
        isSelected: timelineType == TimeLineType.week,
        timeLineType: TimeLineType.week,
        bcontext: bcontext,
      ),
      _ViewOption(
        icon: LucideIcons.calendarRange300,
        title: 'Mês',
        isSelected: timelineType == TimeLineType.month,
        timeLineType: TimeLineType.month,
        bcontext: bcontext,
      ),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1,
      children: options.map((option) {
        return SizedBox(height: 80, child: option);
      }).toList(),
    );
  }
}

class _ViewOption extends StatelessWidget {
  final BuildContext bcontext;
  final IconData icon;
  final String title;
  final bool isSelected;
  final TimeLineType timeLineType;
  const _ViewOption({
    required this.bcontext,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.timeLineType,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        bcontext.read<SchedulesBloc>().add(
          SelectTimelineType(timelineType: timeLineType),
        );

        await Future.delayed(Duration(milliseconds: 200));
        
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: AppColors.secondary, width: 1)
              : Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

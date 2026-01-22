// ignore_for_file: deprecated_member_use

import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

enum AppDateSelectionMode { single, range }

class AppDatePicker extends StatefulWidget {
  final AppDateSelectionMode selectionMode;

  final DateTime? firstDay;
  final DateTime? lastDay;

  final DateTime? selected;

  final DateTime? rangeStart;
  final DateTime? rangeEnd;

  final ValueChanged<DateTime>? onSelected;

  final void Function(DateTime? start, DateTime? end)? onRangeSelected;

  final bool Function(DateTime day)? enabledDayPredicate;

  final String? localeTag;

  final Color? selectedColor;

  final bool enableSwipe;

  const AppDatePicker({
    super.key,
    this.selectionMode = AppDateSelectionMode.single,
    this.firstDay,
    this.lastDay,
    this.selected,
    this.rangeStart,
    this.rangeEnd,
    this.onSelected,
    this.onRangeSelected,
    this.enabledDayPredicate,
    this.localeTag,
    this.selectedColor,
    this.enableSwipe = true,
  });

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  DateTime? _selected;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _selected =
        (widget.selectionMode == AppDateSelectionMode.single)
            ? (widget.selected ?? today)
            : widget.selected;

    _rangeStart = widget.rangeStart;
    _rangeEnd = widget.rangeEnd;

    final first = _effectiveFirstDay(today);
    final last = _effectiveLastDay(today);

    _focusedDay = _clampDay(_initialFocus(today), first, last);
  }

  DateTime _effectiveFirstDay(DateTime today) =>
      widget.firstDay ?? DateTime(1900, 1, 1);

  DateTime _effectiveLastDay(DateTime today) =>
      widget.lastDay ?? DateTime(2100, 12, 31);

  DateTime _initialFocus(DateTime today) {
    switch (widget.selectionMode) {
      case AppDateSelectionMode.single:
        return _selected ?? today;
      case AppDateSelectionMode.range:
        return _rangeStart ?? _rangeEnd ?? today;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final first = _effectiveFirstDay(today);
    final last = _effectiveLastDay(today);

    final localeTag =
        widget.localeTag ?? Localizations.localeOf(context).toLanguageTag();
    final tableLocale = localeTag.replaceAll('-', '_');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: TableCalendar<DateTime>(
                firstDay: first,
                lastDay: last,
                focusedDay: _clampDay(_focusedDay, first, last),
                locale: tableLocale,

                availableGestures:
                    widget.enableSwipe
                        ? AvailableGestures.horizontalSwipe
                        : AvailableGestures.none,
                daysOfWeekVisible: true,
                daysOfWeekHeight: 24,
                startingDayOfWeek: StartingDayOfWeek.sunday,

                selectedDayPredicate:
                    (d) =>
                        widget.selectionMode == AppDateSelectionMode.single &&
                        _selected != null &&
                        d.year == _selected!.year &&
                        d.month == _selected!.month &&
                        d.day == _selected!.day,

                rangeSelectionMode:
                    widget.selectionMode == AppDateSelectionMode.range
                        ? RangeSelectionMode.toggledOn
                        : RangeSelectionMode.toggledOff,
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,

                enabledDayPredicate: (day) {
                  final inBounds = !day.isBefore(first) && !day.isAfter(last);
                  if (!inBounds) return false;
                  return widget.enabledDayPredicate?.call(day) ?? true;
                },

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  leftChevronVisible: true,
                  rightChevronVisible: true,
                  titleTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  titleTextFormatter:
                      (date, _) => _monthTitleShort(date, localeTag),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  dowTextFormatter: (date, _) => _dowLabel(date.weekday, localeTag),
                  weekdayStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                  weekendStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),

                calendarStyle: CalendarStyle(
                  rangeHighlightColor: AppColors.primary.withValues(alpha: 0.4),
                  isTodayHighlighted: false,
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  weekendTextStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                calendarBuilders: CalendarBuilders(
                  rangeStartBuilder:
                      (context, day, _) =>
                          _buildCircleDay(context, day, bg: AppColors.primary),
                  rangeEndBuilder:
                      (context, day, _) =>
                          _buildCircleDay(context, day, bg: AppColors.primary),
                  selectedBuilder:
                      (context, day, _) =>
                          _buildCircleDay(context, day, bg: AppColors.primary),
                  headerTitleBuilder: (context, day) {
                    const globalMinYear = 1925;
                    final globalMaxYear = DateTime.now().year;

                    final minYear =
                        (widget.firstDay?.year ?? globalMinYear) < globalMinYear
                            ? globalMinYear
                            : (widget.firstDay?.year ?? globalMinYear);

                    final maxYear =
                        (widget.lastDay?.year ?? globalMaxYear) > globalMaxYear
                            ? globalMaxYear
                            : (widget.lastDay?.year ?? globalMaxYear);

                    final itemsYear = _yearItems(minYear, maxYear);
                    final currentYear = day.year;

                    final localeTag =
                        widget.localeTag ??
                        Localizations.localeOf(context).toLanguageTag();
                    final tableLocale = localeTag.replaceAll('-', '_');

                    final first = _effectiveFirstDay(DateTime.now());
                    final last = _effectiveLastDay(DateTime.now());

                    final itemsMonth = _monthItems(
                      currentYear,
                      first,
                      last,
                      tableLocale,
                    );
                    final currentMonth = day.month;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 90,
                          child: AppDropdown(
                            items: itemsMonth,
                            labelKey: 'label',
                            valueKey: 'value',
                            selectedValue: currentMonth,
                            onChanged: (val) {
                              if (val == null) return;
                              final m = val as int;
                              final tentative = DateTime(currentYear, m, 1);
                              setState(() {
                                _focusedDay = _clampDay(tentative, first, last);
                              });
                            },
                            borderRadius: 12,
                            borderWidth: 1,
                            dropdownMaxHeight: 280,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 100,
                          child: AppDropdown(
                            items: itemsYear,
                            labelKey: 'label',
                            valueKey: 'value',
                            selectedValue: currentYear,
                            onChanged: (val) {
                              if (val == null) return;
                              final y = val as int;
                              final tentative = DateTime(y, _focusedDay.month, 1);
                              setState(() {
                                _focusedDay = _clampDay(tentative, first, last);
                              });
                            },
                            borderRadius: 12,
                            borderWidth: 1,
                            dropdownMaxHeight: 280,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                onDaySelected: (selected, focused) {
                  if (widget.selectionMode == AppDateSelectionMode.single) {
                    final sel = _clampDay(selected, first, last);
                    setState(() {
                      _selected = sel;
                      _focusedDay = _clampDay(focused, first, last);
                    });
                    widget.onSelected?.call(sel);
                  }
                },

                onRangeSelected: (start, end, focused) {
                  if (widget.selectionMode == AppDateSelectionMode.range) {
                    setState(() {
                      _rangeStart = start;
                      _rangeEnd = end;
                      _focusedDay = _clampDay(focused, first, last);
                    });
                  }
                },

                onPageChanged: (focused) {
                  setState(() {
                    _focusedDay = _clampDay(focused, first, last);
                  });
                },
              ),
            ),
            if (widget.selectionMode == AppDateSelectionMode.range) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_rangeStart == null) {
                        context.pop();
                      } else {
                        final startDate = _rangeStart;
                        final endDate = _rangeEnd ?? _rangeStart!.add(const Duration(days: 1));
                        widget.onRangeSelected?.call(startDate, endDate);
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  DateTime _clampDay(DateTime day, DateTime min, DateTime max) {
    if (day.isBefore(min)) return min;
    if (day.isAfter(max)) return max;
    return day;
  }

  List<Map<String, Object?>> _yearItems(int minYear, int maxYear) {
    final list = <Map<String, Object?>>[];
    for (var y = maxYear; y >= minYear; y--) {
      list.add({'label': y.toString(), 'value': y});
    }
    return list;
  }

  Widget _buildCircleDay(
    BuildContext context,
    DateTime day, {
    required Color bg,
  }) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _monthTitleShort(DateTime date, String localeTag) {
    final s = DateFormat('LLL y', localeTag).format(date);
    return s[0].toLowerCase() == s[0]
        ? s
        : '${s[0].toLowerCase()}${s.substring(1)}';
  }

  String _dowLabel(int weekday, String localeTag) {
    final lang = localeTag.split(RegExp('[-_]')).first;
    if (lang == 'en') {
      const en = {
        DateTime.sunday: 'sun',
        DateTime.monday: 'mon',
        DateTime.tuesday: 'tue',
        DateTime.wednesday: 'wed',
        DateTime.thursday: 'thu',
        DateTime.friday: 'fri',
        DateTime.saturday: 'sat',
      };
      return en[weekday]!;
    }
    const pt = {
      DateTime.sunday: 'dom',
      DateTime.monday: 'seg',
      DateTime.tuesday: 'ter',
      DateTime.wednesday: 'qua',
      DateTime.thursday: 'qui',
      DateTime.friday: 'sex',
      DateTime.saturday: 'sab',
    };
    return pt[weekday]!;
  }

  List<Map<String, Object?>> _monthItems(
    int year,
    DateTime first,
    DateTime last,
    String tableLocale,
  ) {
    final items = <Map<String, Object?>>[];
    for (var m = 1; m <= 12; m++) {
      final monthStart = DateTime(year, m, 1);
      final monthEnd = DateTime(year, m + 1, 0);
      final overlapsRange =
          !(monthEnd.isBefore(first) || monthStart.isAfter(last));
      if (overlapsRange) {
        final label = DateFormat('MMM', tableLocale).format(monthStart);
        items.add({'label': label, 'value': m});
      }
    }
    items.sort((a, b) => (a['value'] as int).compareTo(b['value'] as int));
    return items;
  }
}

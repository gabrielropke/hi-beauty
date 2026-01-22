import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showAddressDataEditSheet({
  required BuildContext context,
  DateTime? dateTime,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => AddOptionsModal(dateTime: dateTime),
  );
}

class AddOptionsModal extends StatelessWidget {
  final DateTime? dateTime;
  const AddOptionsModal({super.key, this.dateTime});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        // reduz padding geral
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // botão fechar com menos padding
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () => context.pop(),
                icon: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: const Icon(LucideIcons.x200),
                ),
              ),
            ),
            const SizedBox(height: 4),

            Text(
              'Adicionar',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            

            if (dateTime != null) ...[
              Text(
                '${DateFormatters.weekdayDayMonthShort(dateTime!, context)} às ${DateFormatters.timeFormat(dateTime!)}',
                style: TextStyle(),
              ),

              
            ],

            const SizedBox(height: 20),

            _OptionItem(
              label: 'Novo agendamento',
              onTap: () {
                context.pop();
                context.push(
                  AppRoutes.addSchedule,
                  extra: AddScheduleArgs(
                    addScheduleType: AddScheduleType.booking,
                    initialDate: dateTime,
                  ),
                );
              },
              icon: LucideIcons.calendarPlus,
            ),
            const SizedBox(height: 16),
            _OptionItem(
              label: 'Bloqueio de agenda',
              onTap: () {
                context.pop();
                context.push(
                  AppRoutes.addSchedule,
                  extra: AddScheduleArgs(
                    addScheduleType: AddScheduleType.block,
                    initialDate: dateTime,
                  ),
                );
              },
              icon: LucideIcons.calendarX,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData icon;
  const _OptionItem({
    required this.label,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          spacing: 12,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

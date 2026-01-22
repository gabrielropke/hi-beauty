import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/features/notifications/data/model.dart';
import 'package:hibeauty/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/add_schedule_screen.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/components/add_schedule_utils.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showNotificationsOptionsSheet({
  required BuildContext context,
  required NotificationModel notification,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => NotificaitonsOptionsModal(
      notification: notification,
      bcontext: context,
    ),
  );
}

Future<void> showAllConfigurations({required BuildContext context}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => AllConfigurationsModal(bcontext: context),
  );
}

class NotificaitonsOptionsModal extends StatelessWidget {
  final BuildContext bcontext;
  final NotificationModel notification;
  const NotificaitonsOptionsModal({
    super.key,
    required this.notification,
    required this.bcontext,
  });

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
              'Ações rápidas',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            if (notification.readAt == null)
              _OptionItem(
                label: 'Marcar como lida',
                onTap: () {
                  bcontext.read<NotificationsBloc>().add(
                    MarkRead(id: notification.id),
                  );
                  context.pop();
                },
                color: Colors.black,
              ),

            // BOOKING
            if (notification.type == 'BOOKING') ...[
              if (notification.bookingId != null &&
                  notification.bookingId!.isNotEmpty)
                _OptionItem(
                  label: 'Ver atividade do agendamento',
                  onTap: () {
                    context.pop();
                    context.push(
                      AppRoutes.addSchedule,
                      extra: AddScheduleArgs(
                        addScheduleType: AddScheduleType.booking,
                        bookingId: notification.bookingId,
                      ),
                    );
                  },
                  color: Colors.black,
                ),
            ],

            _OptionItem(
              label: 'Deletar notificação',
              onTap: () {
                bcontext.read<NotificationsBloc>().add(
                  DeleteNotification(id: notification.id),
                );
                context.pop();
              },
              color: Colors.red,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class AllConfigurationsModal extends StatelessWidget {
  final BuildContext bcontext;
  const AllConfigurationsModal({super.key, required this.bcontext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // botão fechar
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
              'Configurações',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            _OptionItem(
              label: 'Marcar todas como lidas',
              onTap: () {
                bcontext.read<NotificationsBloc>().add(MarkAllRead());
                context.pop();
              },
              color: Colors.black87,
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
  final Color? color;
  const _OptionItem({required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 40,
        width: double.infinity,
        color: Colors.transparent,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: color ?? Colors.black87,
          ),
        ),
      ),
    );
  }
}

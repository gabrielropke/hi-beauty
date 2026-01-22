import 'package:flutter/material.dart';
import 'package:hibeauty/core/constants/formatters/date.dart';
import 'package:hibeauty/features/notifications/data/model.dart';
import 'package:hibeauty/features/notifications/presentation/components/notifications_options_modal.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showNotificationsOptionsSheet(context: context, notification: notification),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: notification.readAt == null
              ? Border.all(width: 1, color: Colors.blue)
              : Border.all(width: 1, color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          if (notification.readAt == null)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification.title
                                  .replaceAll('confirmado', '')
                                  .replaceAll('Confirmado', ''),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        DateFormatters.relativeTimeFormat(
                          DateTime.parse(notification.sentAt),
                        ),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                if (notification.customer == null) _typeIndicator(notification),
                if (notification.customer != null)
                  _customerIndicator(notification),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              notification.description,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeIndicator(NotificationModel notification) {
    final isRead = notification.readAt != null;
    final indicatorColor = isRead ? Colors.grey : Colors.blue;

    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: indicatorColor.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              _getIconByType(notification.type),
              size: 20,
              color: indicatorColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _customerIndicator(NotificationModel notification) {
    final isRead = notification.readAt != null;
    final indicatorColor = isRead ? Colors.grey : Colors.blue;

    return Stack(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: indicatorColor.withValues(alpha: 0.1),
            border: Border.all(color: Colors.white, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              notification.customer!.name.length >= 2
                  ? notification.customer!.name.substring(0, 2).toUpperCase()
                  : notification.customer!.name.characters.first.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: indicatorColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: indicatorColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconByType(notification.type),
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconByType(String type) {
    switch (type.toLowerCase()) {
      case 'booking':
        return LucideIcons.calendarRange;
      case 'payment':
        return LucideIcons.dollarSign;
      case 'notice':
        return LucideIcons.bell;
      case 'system':
        return LucideIcons.settings;
      case 'commission_calculated':
        return LucideIcons.calculator;
      case 'commission_paid':
        return LucideIcons.banknoteArrowUp;
      default:
        return LucideIcons.info;
    }
  }
}

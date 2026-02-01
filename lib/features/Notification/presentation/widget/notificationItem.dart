import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/notification_entity.dart';
import 'notificationIcon.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItem({
    required this.notification,
    required this.onTap,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    bool isToday = dateTime.day == now.day && 
                   dateTime.month == now.month && 
                   dateTime.year == now.year;

    if (isToday) {
      return "${DateFormat('EEEE', 'ar').format(dateTime)}، ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
    } else if (now.difference(dateTime).inDays == 1) {
      return "أمس، ${DateFormat('hh:mm a', 'ar').format(dateTime)}";
    } else {
      return DateFormat('yyyy/MM/dd').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من وجود فاصل | في النص
    final bool hasSeparator = notification.body.contains('|');
    String username = '';
    String message = notification.body;

    if (hasSeparator) {
      final parts = notification.body.split('|').map((p) => p.trim()).toList();
      username = parts[0];
      message = parts.length > 1 ? parts.sublist(1).join(" | ") : '';
    }

    return Material(
      color: notification.isRead
          ? Colors.white
          : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationIcon(type: notification.type),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: notification.isRead
                                  ? Colors.black87
                                  : Colors.blue.shade900,
                            ),
                          ),
                        ),
                        Text(
                          _formatDateTime(notification.createdAt),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                        children: [
                          if (hasSeparator && username.isNotEmpty)
                            TextSpan(
                              text: "$username: ",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          TextSpan(
                            text: message,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(top: 6, right: 8),
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

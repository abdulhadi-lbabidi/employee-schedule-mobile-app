import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final String type;

  const NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (type) {
      case 'attendance':
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      case 'alert':
        icon = Icons.warning_amber_rounded;
        color = Colors.red;
        break;
      case 'message':
        icon = Icons.message;
        color = Colors.blue;
        break;
      default:
        icon = Icons.notifications;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.15),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

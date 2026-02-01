import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPermissionService {

  Future<void> requestPermission() async {
    final plugin = FlutterLocalNotificationsPlugin();

    final androidPlugin =
    plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }
}

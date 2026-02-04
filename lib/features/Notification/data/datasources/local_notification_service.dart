import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(
      onDidReceiveNotificationResponse: (response) {
        // handle notification tapped
      }, settings: settings,
    );
  }

  Future<void> show({required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'attendance_channel',
      'Attendance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // رقم فريد لكل إشعار
      title: "مرحبا",
      body: "هذا إشعار تجريبي",
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'attendance_channel',
          'Attendance Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: "some_payload_if_needed",
    );
  }
}


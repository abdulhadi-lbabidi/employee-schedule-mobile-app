import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String channelId = 'attendance_channel_id'; 
  static const String channelName = 'Attendance Notifications';

  Future<void> init() async {
    // استخدام ic_notification بدلاً من ic_launcher
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('ic_notification');
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
      
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        channelName,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin?.createNotificationChannel(channel);
    }

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> showNotification({required String title, required String body}) async {
    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      icon: 'ic_notification', // استخدام الأيقونة المخصصة هنا
      styleInformation: BigTextStyleInformation(body),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond, 
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }
}

import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/helper/src/prefs_keys.dart';
import '../model/get_all_notifications_response.dart';
import '../model/notification_model.dart';

@lazySingleton
class NotificationLocaleDataSources {
  final SharedPreferences sharedPreferences;

  NotificationLocaleDataSources({required this.sharedPreferences});

  /// ================== GET ==================
  /// جلب كل الإشعارات من الـ SharedPreferences
  Future<GetAllNotificationsResponse> getNotifications() async {
    final jsonString = sharedPreferences.getString(PrefsKeys.localeNotifications);

    if (jsonString == null || jsonString.isEmpty) {
      return GetAllNotificationsResponse(data: []);
    }

    final decoded = json.decode(jsonString);

    List<NotificationModel> allNotifications = [];

    if (decoded is List) {
      allNotifications.addAll(
        decoded.map(
              (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
        ),
      );
    }
    else if (decoded is Map<String, dynamic>) {
      allNotifications.add(NotificationModel.fromJson(decoded));
    } else {
      // fallback إذا كان نوع البيانات غير معروف
      return GetAllNotificationsResponse(data: []);
    }



    return GetAllNotificationsResponse(data: allNotifications);
  }

  /// ================== SET ==================
  /// حفظ قائمة الإشعارات في الـ SharedPreferences
  Future<void> setLocaleNotifications(
      List<NotificationModel> notifications,
      )
  async {
    final jsonString = json.encode(
      notifications.map((e) => e.toJson()).toList(),
    );

    await sharedPreferences.setString(PrefsKeys.localeNotifications, jsonString);
  }

  /// ================== ADD ==================
  /// إضافة إشعار واحد أو أكثر إلى القائمة الحالية
  Future<void> addNotifications(List<NotificationModel> notifications) async {
    final current = await getNotifications();
    final merged = List<NotificationModel>.from(current.data ?? []);

    // منع التكرار حسب ID
    for (final n in notifications) {
      if (!merged.any((e) => e.id == n.id)) {
        merged.add(n);
      }
    }

    await setLocaleNotifications(merged);
  }

  /// ================== REPLACE ==================
  /// استبدال إشعار موجود بناءً على ID
  Future<void> replaceNotification(NotificationModel notification) async {
    final current = await getNotifications();
    final merged = List<NotificationModel>.from(current.data ?? []);

    final index = merged.indexWhere((e) => e.id == notification.id);
    if (index != -1) {
      merged[index] = notification;
      await setLocaleNotifications(merged);
    }
  }
}
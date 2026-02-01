import '../entities/notification_entity.dart';
import '../../data/model/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications(); // 🔹 ميزة حذف الكل
  Future<void> syncNotifications();
  Future<void> addLocalNotification(NotificationModel notification);
  
  Future<void> sendNotification({
    required String title,
    required String body,
    String? targetWorkshop,
    String? targetEmployeeId,
  });
}

import '../entities/notification_entity.dart';
import '../../data/model/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(); // تم التغيير من NotificationEntity إلى NotificationModel
  Future<void> markNotificationAsRead(String id); // تم تغيير الاسم ليتوافق مع UseCase
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
  Future<void> syncNotifications();
  Future<void> addLocalNotification(NotificationModel notification);
  
  Future<void> sendNotification({
    required String title,
    required String body,
    String? targetWorkshop,
    int? targetEmployeeId, // تم التغيير من String? إلى int?
  });
}

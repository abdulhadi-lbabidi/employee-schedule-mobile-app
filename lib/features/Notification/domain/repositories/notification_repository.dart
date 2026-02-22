import 'package:untitled8/common/helper/src/typedef.dart';
import '../../data/model/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications(); // تم التغيير من NotificationEntity إلى NotificationModel
  Future<void> markNotificationAsRead(String id); // تم تغيير الاسم ليتوافق مع UseCase
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
  Future<void> syncNotifications();
  Future<void> addLocalNotification(NotificationModel notification);

  DataResponse<void> sendNotification(BodyMap params);



  DataResponse<void> checkInWorkshop(BodyMap params);
  DataResponse<void> checkOutWorkshop(BodyMap params);



}



import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/features/Notification/data/model/get_all_notifications_response.dart';

abstract class NotificationRepository {
  DataResponse<GetAllNotificationsResponse> getNotifications();
  DataResponse<void> sendNotification(BodyMap params);
  DataResponse<void> checkInWorkshop(BodyMap params);
  DataResponse<void> checkOutWorkshop(BodyMap params);
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
}



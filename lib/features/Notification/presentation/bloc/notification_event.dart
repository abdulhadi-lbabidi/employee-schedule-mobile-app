import 'package:untitled8/features/Notification/domain/usecases/check_in_use_case.dart';
import 'package:untitled8/features/Notification/domain/usecases/send_notification_use_case.dart';

import '../../data/model/notification_model.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;
  MarkNotificationAsRead(this.id);
}

// class SyncNotificationsEvent extends NotificationEvent {}

class AddLocalNotificationEvent extends NotificationEvent {
  final NotificationModel notification;
  AddLocalNotificationEvent(this.notification);
}



class DeleteNotificationEvent extends NotificationEvent {
  final String id;
  DeleteNotificationEvent(this.id);
}

class DeleteAllNotificationsEvent extends NotificationEvent {}


class SendNotificationsEvent extends NotificationEvent{
   final SendNotificationParams params;

  SendNotificationsEvent({required this.params});

}
class CheckInEvent extends NotificationEvent{
   final CheckInParams params;

  CheckInEvent({required this.params});

}
class CheckOutEvent extends NotificationEvent{
   final CheckInParams params;

  CheckOutEvent({required this.params});

}
class NotificationError extends NotificationEvent{
   final String message;

  NotificationError(this.message);

}


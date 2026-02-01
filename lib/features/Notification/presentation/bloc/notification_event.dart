import '../../data/model/notification_model.dart';

abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {}

class MarkNotificationAsRead extends NotificationEvent {
  final String id;
  MarkNotificationAsRead(this.id);
}

class SyncNotificationsEvent extends NotificationEvent {}

class AddLocalNotificationEvent extends NotificationEvent {
  final NotificationModel notification;
  AddLocalNotificationEvent(this.notification);
}

class AdminSendNotificationEvent extends NotificationEvent {
  final String title;
  final String body;
  final String? targetWorkshop; 
  final String? targetEmployeeId; 

  AdminSendNotificationEvent({
    required this.title,
    required this.body,
    this.targetWorkshop,
    this.targetEmployeeId,
  });
}

class DeleteNotificationEvent extends NotificationEvent {
  final String id;
  DeleteNotificationEvent(this.id);
}

class DeleteAllNotificationsEvent extends NotificationEvent {}

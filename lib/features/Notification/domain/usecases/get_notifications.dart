import 'package:injectable/injectable.dart';
import '../../data/model/notification_model.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';
@lazySingleton
class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return repository.getNotifications();
  }
}
@lazySingleton
class AddLocalNotificationUseCase {
  final NotificationRepository repository;

  AddLocalNotificationUseCase(this.repository);

  Future<void> call(NotificationModel notification) async {
    await repository.addLocalNotification(notification);
  }
}
@lazySingleton
class SyncNotificationsUseCase {
  final NotificationRepository repository;

  SyncNotificationsUseCase(this.repository);

  Future<void> call() async {
    await repository.syncNotifications();
  }
}
@lazySingleton
class SendNotificationUseCase {
  final NotificationRepository repository;

  SendNotificationUseCase(this.repository);

  Future<void> call({
    required String title,
    required String body,
    String? targetWorkshop,
    String? targetEmployeeId,
  }) async {
    await repository.sendNotification(
      title: title,
      body: body,
      targetWorkshop: targetWorkshop,
      targetEmployeeId: targetEmployeeId,
    );
  }
}
@lazySingleton
class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteNotification(id);
  }
}
@lazySingleton
class DeleteAllNotificationsUseCase {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  Future<void> call() async {
    await repository.deleteAllNotifications();
  }
}
@lazySingleton
class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.markAsRead(id);
  }
}

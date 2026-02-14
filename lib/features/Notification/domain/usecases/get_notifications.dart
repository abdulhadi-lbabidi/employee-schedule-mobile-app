import 'package:injectable/injectable.dart';
import '../repositories/notification_repository.dart';
import '../../data/model/notification_model.dart';

@injectable
class GetNotificationsUseCase {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  Future<List<NotificationModel>> call() async { // تم التغيير من NotificationEntity إلى NotificationModel
    return await repository.getNotifications();
  }
}

@injectable
class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;
  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.markNotificationAsRead(id);
  }
}

@injectable
class SendNotificationUseCase {
  final NotificationRepository repository;
  SendNotificationUseCase(this.repository);

  Future<void> call({
    required String title,
    required String body,
    String? targetWorkshop,
    int? targetEmployeeId, // هذا النوع أصبح صحيحاً الآن
  }) async {
    return await repository.sendNotification(
      title: title,
      body: body,
      targetWorkshop: targetWorkshop,
      targetEmployeeId: targetEmployeeId,
    );
  }
}

@injectable
class SyncNotificationsUseCase {
  final NotificationRepository repository;
  SyncNotificationsUseCase(this.repository);

  Future<void> call() async {
    return await repository.syncNotifications();
  }
}

@injectable
class AddLocalNotificationUseCase {
  final NotificationRepository repository;
  AddLocalNotificationUseCase(this.repository);

  Future<void> call(NotificationModel notification) async {
    return await repository.addLocalNotification(notification);
  }
}

@injectable
class DeleteNotificationUseCase {
  final NotificationRepository repository;
  DeleteNotificationUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteNotification(id);
  }
}

@injectable
class DeleteAllNotificationsUseCase {
  final NotificationRepository repository;
  DeleteAllNotificationsUseCase(this.repository);

  Future<void> call() async {
    return await repository.deleteAllNotifications();
  }
}

import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
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

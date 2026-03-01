import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../data/model/get_all_notifications_response.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationsUseCase {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  DataResponse<GetAllNotificationsResponse> call() async { // تم التغيير من NotificationEntity إلى NotificationModel
    return await repository.getNotifications();
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

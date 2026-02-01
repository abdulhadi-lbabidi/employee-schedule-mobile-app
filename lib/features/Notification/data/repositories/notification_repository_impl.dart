import 'package:hive/hive.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../model/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Box<NotificationModel> localBox;
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.localBox, required this.remoteDataSource});

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    return localBox.values.map(_mapToEntity).toList();
  }

  @override
  Future<void> addLocalNotification(NotificationModel notification) async {
    await localBox.put(notification.id, notification);
  }

  @override
  Future<void> syncNotifications() async {
    try {
      final remoteNotifications = await remoteDataSource.fetchNotifications();
      for (var model in remoteNotifications) {
        if (!localBox.containsKey(model.id)) {
          await localBox.put(model.id, model);
        }
      }
    } catch (_) {}
  }

  @override
  Future<void> sendNotification({
    required String title, 
    required String body, 
    String? targetWorkshop,
    String? targetEmployeeId,
  }) async {
    await remoteDataSource.sendNotification(
      title: title, 
      body: body, 
      targetWorkshop: targetWorkshop,
      targetEmployeeId: targetEmployeeId,
    );
    
    final localNotif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
      type: 'admin_broadcast',
      isRead: false,
    );
    await addLocalNotification(localNotif);
  }

  @override
  Future<void> deleteNotification(String id) async {
    // يمكن هنا استدعاء السيرفر لحذف الإشعار من هناك أيضاً إذا كان ذلك مطلوباً
    // await remoteDataSource.deleteNotification(id); 
    await localBox.delete(id);
  }

  @override
  Future<void> deleteAllNotifications() async {
    await localBox.clear();
  }

  @override
  Future<void> markAsRead(String id) async {
    final model = localBox.get(id);
    if (model != null) {
      model.isRead = true;
      await model.save();
    }
  }

  NotificationEntity _mapToEntity(NotificationModel model) {
    return NotificationEntity(
      id: model.id,
      title: model.title,
      body: model.body,
      type: model.type,
      isRead: model.isRead,
      createdAt: model.createdAt,
    );
  }
}

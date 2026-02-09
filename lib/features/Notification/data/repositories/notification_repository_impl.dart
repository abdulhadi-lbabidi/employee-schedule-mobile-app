import 'package:flutter/cupertino.dart'; // Keep this import as debugPrint is used
import 'package:hive/hive.dart';
import '../../../../core/hive_service.dart';
// import '../../domain/entities/notification_entity.dart'; // No longer needed directly for getNotifications return type
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../model/notification_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final HiveService hiveService;
  final NotificationRemoteDataSourceImpl remoteDataSource; // Assuming this is correct

  NotificationRepositoryImpl({
    required this.hiveService,
    required this.remoteDataSource,
  });

  /// 🔹 جلب Box الإشعارات من HiveService
  Future<Box<NotificationModel>> get _box async =>
      await hiveService.notificationBox;

  /// 🔹 جلب كل الإشعارات المخزنة محلياً (كـ Models)
  @override
  Future<List<NotificationModel>> getNotifications() async { // Changed return type to List<NotificationModel>
    final box = await _box;
    return box.values.toList(); // Directly return list of models
  }

  /// 🔹 إضافة إشعار محلي في الـ Hive
  @override
  Future<void> addLocalNotification(NotificationModel notification) async {
    final box = await _box;
    await box.put(notification.id, notification);
  }

  /// 🔹 مزامنة الإشعارات مع السيرفر
  /// إذا كانت الإشعار موجودة محلياً، لا يتم إضافتها مرتين
  @override
  Future<void> syncNotifications() async {
    try {
      final remoteNotifications = await remoteDataSource.fetchNotifications();
      final box = await _box;
      for (var model in remoteNotifications) {
        if (!box.containsKey(model.id)) {
          await box.put(model.id, model);
        }
      }
    } catch (e) {
      debugPrint("Sync notifications failed: $e");
    }
  }

  /// 🔹 إرسال إشعار للسيرفر وإضافة نسخة محلية
  @override
  Future<void> sendNotification({
    required String title,
    required String body,
    String? targetWorkshop,
    int? targetEmployeeId, // Changed type to int?
  }) async {
    await remoteDataSource.sendNotification(
      title: title,
      body: body,
      targetWorkshop: targetWorkshop,
      targetEmployeeId: targetEmployeeId, // Pass int?
    );

    final localNotif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // ID is String here as per NotificationModel
      title: title,
      body: body,
      createdAt: DateTime.now(),
      type: 'admin_broadcast',
      isRead: false,
    );

    await addLocalNotification(localNotif);
  }

  /// 🔹 حذف إشعار محدد محلياً
  @override
  Future<void> deleteNotification(String id) async {
    final box = await _box;
    await box.delete(id);
  }

  /// 🔹 حذف كل الإشعارات محلياً
  @override
  Future<void> deleteAllNotifications() async {
    final box = await _box;
    await box.clear();
  }

  /// 🔹 وضع إشعار كمقروء
  @override
  Future<void> markNotificationAsRead(String id) async { // Corrected method name to match interface
    final box = await _box;
    final model = box.get(id);
    if (model != null) {
      model.isRead = true;
      await model.save();
    }
  }
}

import '../model/notification_model.dart';
import 'notification_remote_data_source.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationRemoteDataSourceMock  {
  final List<NotificationModel> _mockNotifications = [];

  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockNotifications;
  }

  Future<void> sendNotification({
    required String title, 
    required String body, 
    String? targetWorkshop,
    String? targetEmployeeId, // 🔹 تم إضافة الحقل المفقود هنا
  })
  async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newNotif = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body + (targetEmployeeId != null ? " (موجه لموظف)" : ""),
      type: 'admin_broadcast',
      isRead: false,
      createdAt: DateTime.now(),
    );
    
    _mockNotifications.insert(0, newNotif);
    print('MOCK NOTIF API: Notification Sent to $targetEmployeeId in $targetWorkshop');
  }

  Future<void> deleteNotification(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockNotifications.removeWhere((n) => n.id == id);
  }
}

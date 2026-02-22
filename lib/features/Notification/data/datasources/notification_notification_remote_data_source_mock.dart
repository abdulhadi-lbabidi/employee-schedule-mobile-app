// import 'package:untitled8/common/helper/src/typedef.dart';
// import 'package:untitled8/core/unified_api/api_variables.dart';
// import 'package:untitled8/core/unified_api/base_api.dart';
// import 'package:untitled8/core/unified_api/handling_api_manager.dart';
// import 'package:injectable/injectable.dart';
//
// @lazySingleton
// class NotificationRemoteDataSourceMock with HandlingApiManager {
//   // final List<NotificationModel> _mockNotifications = [];
//
//   // Future<List<NotificationModel>> fetchNotifications() async {
//   //   await Future.delayed(const Duration(milliseconds: 500));
//   //   return _mockNotifications;
//   // }
//   final BaseApi _baseApi;
//
//   NotificationRemoteDataSourceMock({required BaseApi baseApi})
//     : _baseApi = baseApi;
//
//   // Future<void> sendNotification({
//   //   required String title,
//   //   required String body,
//   //   String? targetWorkshop,
//   //   String? targetEmployeeId, // 🔹 تم إضافة الحقل المفقود هنا
//   // })
//   // async {
//   //   await Future.delayed(const Duration(milliseconds: 500));
//   //
//   //   final newNotif = NotificationModel(
//   //     id: DateTime.now().millisecondsSinceEpoch.toString(),
//   //     title: title,
//   //     body: body + (targetEmployeeId != null ? " (موجه لموظف)" : ""),
//   //     type: 'admin_broadcast',
//   //     isRead: false,
//   //     createdAt: DateTime.now(),
//   //   );
//   //
//   //   _mockNotifications.insert(0, newNotif);
//   //   print('MOCK NOTIF API: Notification Sent to $targetEmployeeId in $targetWorkshop');
//   // }
//
//
//   // Future<void> deleteNotification(String id) async {
//   //   await Future.delayed(const Duration(milliseconds: 300));
//   //   _mockNotifications.removeWhere((n) => n.id == id);
//   // }
// }

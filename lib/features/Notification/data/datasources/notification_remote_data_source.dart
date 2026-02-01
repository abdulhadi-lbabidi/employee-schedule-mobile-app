import 'package:dio/dio.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
  
  Future<void> sendNotification({
    required String title, 
    required String body, 
    String? targetWorkshop,
    String? targetEmployeeId,
  });
  
  Future<void> deleteNotification(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;
  final ApiVariables apiVariables = ApiVariables();
  
  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await dio.getUri(apiVariables.notifications());
    final List data = response.data['data'];
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<void> sendNotification({
    required String title, 
    required String body, 
    String? targetWorkshop,
    String? targetEmployeeId,
  }) async {
    await dio.postUri(apiVariables.sendNotification(), data: {
      'title': title,
      'body': body,
      'workshop': targetWorkshop,
      'employee_id': targetEmployeeId,
    });
  }

  @override
  Future<void> deleteNotification(String id) async {
    await dio.deleteUri(apiVariables.deleteNotification(id));
  }
}

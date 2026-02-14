import 'package:dio/dio.dart';
import 'package:http/http.dart' as baseApi;
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../../../core/unified_api/handling_api_manager.dart';
import '../model/notification_model.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
class NotificationRemoteDataSourceImpl with HandlingApiManager{
  final BaseApi _baseApi;

  NotificationRemoteDataSourceImpl({required BaseApi baseApi}) : _baseApi = baseApi;


  Future<List<NotificationModel>> fetchNotifications() async {

    return wrapHandlingApi(
      tryCall:
          () => _baseApi.get(
        ApiVariables.notifications(),
      ),
      jsonConvert: (data){
        final  val =data['data'];
        return val.map((e) => NotificationModel.fromJson(e)).toList();
      },
    );
  }

  Future<void> sendNotification({
    required String title, 
    required String body, 
    String? targetWorkshop,
    int? targetEmployeeId, // تم التعديل من String? إلى int?
  })
  async {

    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
            ApiVariables.sendNotification(),
              data: {
                'title': title,
                'body': body,
                'workshop': targetWorkshop,
                'employee_id': targetEmployeeId, // هذا سيقوم الآن بتمرير int? بشكل صحيح
              }
      ),
      jsonConvert: (data){
       return ;
      },
    );
  }

  Future<void> deleteNotification(String id) async {

    return wrapHandlingApi(
      tryCall:
          () => _baseApi.delete(
              ApiVariables.deleteNotification(id),

      ),
      jsonConvert: (data){
        return ;
      },
    );
  }
}

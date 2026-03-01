import 'package:dio/dio.dart';
import 'package:http/http.dart' as baseApi;
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../../../core/unified_api/handling_api_manager.dart';
import '../model/get_all_notifications_response.dart';
import '../model/notification_model.dart';
import 'package:injectable/injectable.dart';


@lazySingleton
class NotificationRemoteDataSourceImpl with HandlingApiManager{
  final BaseApi _baseApi;

  NotificationRemoteDataSourceImpl({required BaseApi baseApi}) : _baseApi = baseApi;



  // Future<void> sendNotification({
  //   required String title,
  //   required String body,
  //   String? targetWorkshop,
  //   int? targetEmployeeId, // تم التعديل من String? إلى int?
  // })
  // async {
  //
  //   return wrapHandlingApi(
  //     tryCall:
  //         () => _baseApi.post(
  //           ApiVariables.sendNotification(),
  //             data: {
  //               'title': title,
  //               'body': body,
  //               'workshop': targetWorkshop,
  //               'employee_id': targetEmployeeId, // هذا سيقوم الآن بتمرير int? بشكل صحيح
  //             }
  //     ),
  //     jsonConvert: (data){
  //      return ;
  //     },
  //   );
  // }
  Future<void> sendNotification(BodyMap params) async => await wrapHandlingApi(
    tryCall: () => _baseApi.post(ApiVariables.sendNotification(), data: params),
    jsonConvert: (_) {},
  );

  Future<void> checkIn(BodyMap params) async => await wrapHandlingApi(
    tryCall:
        () => _baseApi.post(ApiVariables.checkInNotification(), data: params),
    jsonConvert: (_) {},
  );

  Future<void> checkOut(BodyMap params) async => await wrapHandlingApi(
    tryCall:
        () => _baseApi.post(ApiVariables.checkOutNotification(), data: params),
    jsonConvert: (_) {},
  );

  Future<void> deleteNotification(String id) async {

    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
              ApiVariables.deleteNotification(id),

      ),
      jsonConvert: (data){
        return ;
      },
    );
  }

  Future<void> deleteAllNotification() async {

    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
        ApiVariables.deleteAllNotification(),

      ),
      jsonConvert: (data){
        return ;
      },
    );
  }

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

  Future<GetAllNotificationsResponse> getAllNotifications() async => await wrapHandlingApi(
    tryCall:
        () => _baseApi.get(ApiVariables.getNotification()),
    jsonConvert: getAllNotificationsResponseFromJson,
  );

}

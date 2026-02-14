import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/api_variables.dart';
import 'package:untitled8/core/unified_api/base_api.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import '../../domin/use_cases/get_employee_attendance_use_case.dart';
import '../../domin/use_cases/sync_attendance_use_case.dart';
import '../models/get_attendance_response.dart';
import '../models/sync_attendance_response.dart';

@lazySingleton
class AttendanceRemoteData with HandlingApiManager {
  final BaseApi _baseApi;

  AttendanceRemoteData({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<List<GetAttendanceResponse>> getEmployeeAttendance(GetEmployeeAttendanceParams params) async {
    return wrapHandlingApi(
      tryCall: () => _baseApi.get(ApiVariables.getAttendances(params: params.getParams())),
      jsonConvert: getAttendanceResponseFromJson,
    );
  }

  Future<SyncAttendanceResponse> syncAttendance(SyncAttendanceParams params)
  async {
    return wrapHandlingApi(
      tryCall:
          () => _baseApi.post(
            ApiVariables.syncAttendance(),
            data: params.getList(),
          ),
      jsonConvert: syncAttendanceResponseFromJson,
    );
  }
}

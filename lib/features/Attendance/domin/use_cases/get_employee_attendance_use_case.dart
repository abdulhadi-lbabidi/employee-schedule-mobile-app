import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/models/get_attendance_response.dart';
import '../repositories/attendance_repositories.dart';

@lazySingleton
class GetEmployeeAttendanceUseCase
    implements UseCase<List<GetAttendanceResponse>, GetEmployeeAttendanceParams> {
  final AttendanceRepositories _authRepositories;

  GetEmployeeAttendanceUseCase({required AttendanceRepositories authRepositories})
      : _authRepositories = authRepositories;

  @override
  DataResponse<List<GetAttendanceResponse>> call(
      GetEmployeeAttendanceParams params,
      ) async {
    return _authRepositories.getEmployeeAttendance(params);
  }
}

class GetEmployeeAttendanceParams with Params{
  final int? month;

  GetEmployeeAttendanceParams({required this.month});

  @override
  QueryParams getParams() {
    // TODO: implement getParams
    return {
      "filter[month]":month.toString()

    }..removeWhere((key,value)=>value==null||value=='null'||value=='');
  }
}

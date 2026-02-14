


import 'package:untitled8/common/helper/src/typedef.dart';

import '../../data/models/get_attendance_response.dart';
import '../../data/models/sync_attendance_response.dart';
import '../use_cases/get_employee_attendance_use_case.dart';
import '../use_cases/sync_attendance_use_case.dart';

abstract class AttendanceRepositories {

    DataResponse <List<GetAttendanceResponse>> getEmployeeAttendance(GetEmployeeAttendanceParams params);
    DataResponse <SyncAttendanceResponse> syncAttendance(SyncAttendanceParams  params);

}
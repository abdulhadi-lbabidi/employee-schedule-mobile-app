


import 'package:untitled8/common/helper/src/typedef.dart';

import '../../data/models/get_attendance_response.dart';
import '../use_cases/sync_attendance_use_case.dart';

abstract class AttendanceRepositories {

    DataResponse <GetAttendanceResponse> getEmployeeAttendance();
    DataResponse <GetAttendanceResponse> syncAttendance(SyncAttendanceParams  params);

}
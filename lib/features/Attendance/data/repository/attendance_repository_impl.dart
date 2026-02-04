import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/features/Attendance/data/data_source/attendance_locale_data_source.dart';
import 'package:untitled8/features/Attendance/data/data_source/attendance_remote_data.dart';
import 'package:untitled8/features/Attendance/data/models/get_attendance_response.dart';
import 'package:untitled8/features/Attendance/domin/use_cases/sync_attendance_use_case.dart';
import '../../domin/repositories/attendance_repositories.dart';

@LazySingleton(as: AttendanceRepositories)
class AttendanceRepositoryImpl
    with HandlingException
    implements AttendanceRepositories {
  final AttendanceRemoteData remote;
  final AttendanceLocaleDataSource local;
  final Connectivity connectivity;

  AttendanceRepositoryImpl({
    required this.remote,
    required this.local,
    required this.connectivity,
  });

  @override
  DataResponse<GetAttendanceResponse> getEmployeeAttendance() async =>
      wrapHandlingException(tryCall: () => remote.getEmployeeAttendance(),
        otherCall: ()=>local.getAttendance()
      );

  @override
  DataResponse<GetAttendanceResponse> syncAttendance(
    SyncAttendanceParams params,
  ) async =>
      wrapHandlingException(tryCall: () => remote.syncAttendance(params));
}

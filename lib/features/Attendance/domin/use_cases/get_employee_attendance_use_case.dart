import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/models/get_attendance_response.dart';
import '../repositories/attendance_repositories.dart';

@lazySingleton
class GetEmployeeAttendanceUseCase
    implements UseCase<GetAttendanceResponse, NoParams> {
  final AttendanceRepositories _authRepositories;

  GetEmployeeAttendanceUseCase({required AttendanceRepositories authRepositories})
      : _authRepositories = authRepositories;

  @override
  DataResponse<GetAttendanceResponse> call(
      NoParams params,
      ) async {
    return _authRepositories.getEmployeeAttendance();
  }
}

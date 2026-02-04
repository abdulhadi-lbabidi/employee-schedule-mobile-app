import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/models/get_attendance_response.dart';
import '../repositories/attendance_repositories.dart';

@lazySingleton
class SyncAttendanceUseCase
    implements UseCase<GetAttendanceResponse, SyncAttendanceParams> {
  final AttendanceRepositories _repositories;

  SyncAttendanceUseCase({required AttendanceRepositories repositories})
    : _repositories = repositories;

  @override
  DataResponse<GetAttendanceResponse> call(SyncAttendanceParams params) async {
    return _repositories.syncAttendance(params);
  }
}

class SyncAttendanceParams with Params {
  final List<AttendanceBody> attendanceBody;

  SyncAttendanceParams({required this.attendanceBody});

  List<Map<String, dynamic>> getList() {
    // TODO: implement getBody
    return attendanceBody.map((e) => e.toJson()).toList();
  }
}

class AttendanceBody {
  final int? employeeId;
  final int? workshopId;
  final String? date;
  final String? checkIn;
  final String? checkOut;
  final int? weekNumber;
  final int? regularHours;
  final int? overtimeHours;
  final String? note;
  final String? status;

  AttendanceBody({
    this.employeeId,
    this.workshopId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.weekNumber,
    this.regularHours,
    this.overtimeHours,
    this.note,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "employee_id": employeeId,
      "workshop_id": workshopId,
      "date": formatDate(date),
        "check_in": extractTime(checkIn),
      "check_out": extractTime(checkOut),
      "week_number": weekNumber,
      "regular_hours": regularHours,
      "overtime_hours": overtimeHours,
      "note": note,
      "status": "قيد الرفع",
    };

    map.removeWhere((key, value) => value == null || value == '');
    return map;
  }
}

String formatDate(String? date) {
  if (date == null || date.isEmpty) return '0';

  try {
    final dt = DateTime.parse(date);
    return '${dt.day.toString().padLeft(2, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.year}';
  } catch (_) {
    return '0';
  }
}
String extractTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) return "00:00:00";

  try {
    final dt = DateTime.parse(dateTimeString);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  } catch (_) {
    return "00:00:00";
  }
}

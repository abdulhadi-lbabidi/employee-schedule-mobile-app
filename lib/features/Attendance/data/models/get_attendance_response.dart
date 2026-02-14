

import 'attendance_model.dart';

List<GetAttendanceResponse> getAttendanceResponseFromJson( str) => List<GetAttendanceResponse>.from(str.map((x) => GetAttendanceResponse.fromJson(x)));


class GetAttendanceResponse {
  final DateTime? startDate;
  final DateTime? endDate;

  final int? totalRegularHours;
  final int? totalOvertimeHours;
  final List<AttendanceModel>? attendances;

  /// الإضافة الجديدة: رقم الأسبوع داخل الشهر
  final int? weekOfMonth;

  GetAttendanceResponse({
    this.startDate,
    this.endDate,
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.attendances,
    this.weekOfMonth,
  });

  GetAttendanceResponse copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? totalRegularHours,
    int? totalOvertimeHours,
    List<AttendanceModel>? attendances,
    int? weekOfMonth,
  }) =>
      GetAttendanceResponse(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        totalRegularHours:
        totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours:
        totalOvertimeHours ?? this.totalOvertimeHours,
        attendances: attendances ?? this.attendances,
        weekOfMonth: weekOfMonth ?? this.weekOfMonth,
      );

  factory GetAttendanceResponse.fromJson(
      Map<String, dynamic> json) {
    DateTime? start;
    DateTime? end;

    // دعم الصيغة القديمة "2026-02-07 إلى 2026-02-13"
    final weekString = json["week"];
    if (weekString != null && weekString is String) {
      final parts = weekString.split("إلى");
      if (parts.length == 2) {
        start = DateTime.tryParse(parts[0].trim());
        end = DateTime.tryParse(parts[1].trim());
      }
    }

    // دعم start_date / end_date من backend
    start ??= json["start_date"] != null
        ? DateTime.tryParse(json["start_date"])
        : null;
    end ??= json["end_date"] != null
        ? DateTime.tryParse(json["end_date"])
        : null;

    // ======= حساب رقم الأسبوع داخل الشهر =======
    int? computedWeekOfMonth;
    if (start != null) {
      final firstDayOfMonth = DateTime(start.year, start.month, 1);
      final dayOffset = start.day - 1;
      computedWeekOfMonth = (dayOffset ~/ 7) + 1;
    }

    return GetAttendanceResponse(
      startDate: start,
      endDate: end,
      totalRegularHours: json["total_regular_hours"],
      totalOvertimeHours: json["total_overtime_hours"],
      attendances: json["attendances"] == null
          ? []
          : List<AttendanceModel>.from(
        json["attendances"]
            .map((x) => AttendanceModel.fromJson(x)),
      ),
      weekOfMonth: computedWeekOfMonth,
    );
  }

  Map<String, dynamic> toJson() => {
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
    "attendances":
    attendances?.map((x) => x.toJson()).toList() ?? [],
    "week_of_month": weekOfMonth,
  };

  /// للعرض فقط (كما كان)
  String get weekLabel {
    if (startDate == null || endDate == null) return "";
    return "${startDate!.toIso8601String().split('T').first} "
        "إلى "
        "${endDate!.toIso8601String().split('T').first}";
  }

  /// فحص هل تاريخ داخل هذا الأسبوع
  bool containsDate(DateTime date) {
    if (startDate == null || endDate == null) return false;

    final normalized = DateTime(date.year, date.month, date.day);

    return !normalized.isBefore(
      DateTime(startDate!.year, startDate!.month, startDate!.day),
    ) &&
        !normalized.isAfter(
          DateTime(endDate!.year, endDate!.month, endDate!.day),
        );
  }
}



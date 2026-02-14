

import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';

SyncAttendanceResponse syncAttendanceResponseFromJson( str) => SyncAttendanceResponse.fromJson(str);


class SyncAttendanceResponse {
  final List<AttendanceModel>? data;

  SyncAttendanceResponse({
    this.data,
  });

  SyncAttendanceResponse copyWith({
    List<AttendanceModel>? data,
  }) =>
      SyncAttendanceResponse(
        data: data ?? this.data,
      );

  factory SyncAttendanceResponse.fromJson(Map<String, dynamic> json) => SyncAttendanceResponse(
    data: json["data"] == null ? [] : List<AttendanceModel>.from(json["data"]!.map((x) => AttendanceModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}



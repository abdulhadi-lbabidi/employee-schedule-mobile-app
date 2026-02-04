import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled8/features/Attendance/data/models/attendance_model.dart';
import 'package:untitled8/features/Attendance/data/models/get_attendance_response.dart';
import '../../../../common/helper/src/prefs_keys.dart';
import 'dart:convert';

@lazySingleton
class AttendanceLocaleDataSource {
  final SharedPreferences sharedPreferences;

  AttendanceLocaleDataSource({required this.sharedPreferences});

  Future<GetAttendanceResponse> getAttendance() async {
    final jsonString = sharedPreferences.getString(PrefsKeys.localeAttendance);

    if (jsonString == null) {
      return GetAttendanceResponse(data: []);
    }

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return GetAttendanceResponse.fromJson(jsonMap);
  }

  Future<void> setLocaleAttendance(
      GetAttendanceResponse? response,
      )
  async {
    if (response == null) return;

    final Map<String, dynamic> jsonMap = {
      "data": response.data?.map((e) => e.toJson()).toList() ?? [],
      "links": response.links?.toJson(),
      "meta": response.meta?.toJson(),
    };

    final jsonString = json.encode(jsonMap);

    await sharedPreferences.setString(
      PrefsKeys.localeAttendance,
      jsonString,
    );
  }


  Future<void> addAttendance(AttendanceModel attendance) async {
    final response = await getAttendance();

    final  List<AttendanceModel> updatedList = [
      ...(response.data ?? []),
      attendance,
    ];

    await setLocaleAttendance(
      response.copyWith(data: updatedList),
    );
  }

  Future<void> patchAttendance(AttendanceModel attendance) async {
    final response = await getAttendance();

    final  List<AttendanceModel> updatedList =response.data!.map((e)=>
    e.id==attendance.id?attendance :e
    ).toList();

    await setLocaleAttendance(
      response.copyWith(data: updatedList),
    );
  }


  Future<void> clearAttendance() async {
    await sharedPreferences.remove(PrefsKeys.localeAttendance);
  }





}

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

  /// ================== GET ==================
  /// ================== GET حسب الشهر ==================
  Future<List<GetAttendanceResponse>> getAttendance({int? month}) async {
    final jsonString = sharedPreferences.getString(PrefsKeys.localeAttendance);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final decoded = json.decode(jsonString);

    // تحويل الـ JSON إلى قائمة
    final List<GetAttendanceResponse> allWeeks = [];

    if (decoded is List) {
      // إذا كان JSON عبارة عن قائمة
      allWeeks.addAll(decoded.map((e) => GetAttendanceResponse.fromJson(e as Map<String, dynamic>)));
    } else if (decoded is Map<String, dynamic>) {
      // إذا كان JSON عبارة عن عنصر واحد مخزن كخريطة
      allWeeks.add(GetAttendanceResponse.fromJson(decoded));
    } else {
      // fallback
      return [];
    }

    // ترشيح حسب الشهر إذا تم تمريره
    if (month == null) return allWeeks;

    return allWeeks.where((week) {
      final startMonth = week.startDate?.month;
      final endMonth = week.endDate?.month;

      if (startMonth == null || endMonth == null) return false;

      // أي تداخل مع الشهر المطلوب
      return month >= startMonth && month <= endMonth;
    }).toList();
  }

  /// ================== SET ==================
  Future<void> setLocaleAttendance(
      List<GetAttendanceResponse> responses,
      )
  async {
    final jsonString = json.encode(
      responses.map((e) => e.toJson()).toList(),
    );

    await sharedPreferences.setString(
      PrefsKeys.localeAttendance,
      jsonString,
    );
  }

  /// ================== ADD ATTENDANCE ==================
  Future<void> addAttendance({
    required AttendanceModel attendance,
  })
  async {
    final responses = await getAttendance();

    if (attendance.date == null) return;

    final index = responses.indexWhere(
          (week) => week.containsDate(attendance.date!),
    );

    if (index != -1) {
      final oldWeek = responses[index];

      final updatedAttendances = [
        ...(oldWeek.attendances ?? const <AttendanceModel>[]),
        attendance,
      ];

      responses[index] =
          oldWeek.copyWith(attendances: updatedAttendances);
    } else {
      /// إذا لم نجد أسبوع يحتوي هذا التاريخ
      /// نحسب بداية ونهاية الأسبوع تلقائياً
      final date = attendance.date!;
      final startOfWeek =
      date.subtract(Duration(days: date.weekday - 1));
      final endOfWeek =
      startOfWeek.add(const Duration(days: 6));

      responses.add(
        GetAttendanceResponse(
          startDate: DateTime(
              startOfWeek.year,
              startOfWeek.month,
              startOfWeek.day),
          endDate: DateTime(
              endOfWeek.year,
              endOfWeek.month,
              endOfWeek.day),
          attendances: [attendance],
          totalRegularHours: 0,
          totalOvertimeHours: 0,
        ),
      );
    }

    await setLocaleAttendance(responses);
  }


  /// ================== PATCH ==================
  Future<void> patchAttendance({
    required AttendanceModel attendance,
  })
  async {
    final responses = await getAttendance();

    if (attendance.date == null) return;

    final index = responses.indexWhere(
          (week) => week.containsDate(attendance.date!),
    );

    if (index == -1) return;

    final oldWeek = responses[index];

    final updatedList = oldWeek.attendances
        ?.map((e) => e.id == attendance.id ? attendance : e)
        .toList();

    responses[index] =
        oldWeek.copyWith(attendances: updatedList);

    await setLocaleAttendance(responses);
  }


  /// ================== CLEAR ==================
  Future<void> clearAttendance() async {
    await sharedPreferences.remove(PrefsKeys.localeAttendance);
  }

}


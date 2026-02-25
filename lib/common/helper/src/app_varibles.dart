import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled8/common/helper/src/prefs_keys.dart';
import 'package:untitled8/features/Attendance/data/models/attendance_model.dart'
    hide User;
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';
import '../../../core/di/injection.dart';
import '../../../features/auth/data/model/login_response.dart';

class AppVariables {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final SharedPreferences _pref = sl<SharedPreferences>();

  // ------------------- Token -------------------
  static String? get token => _pref.getString(PrefsKeys.token);

  static set token(String? value) {
    if (value == null) {
      _pref.remove(PrefsKeys.token);
    } else {
      _pref.setString(PrefsKeys.token, value);
    }
  }

  static String? get fcmToken => _pref.getString(PrefsKeys.fcmToken);

  static set fcmToken(String? value) {
    if (value == null) {
      _pref.remove(PrefsKeys.fcmToken);
    } else {
      _pref.setString(PrefsKeys.fcmToken, value);
    }
  }


  // ------------------- Role -------------------
  static String? get role => _pref.getString(PrefsKeys.role);

  static set role(String? value) {
    if (value == null) {
      _pref.remove(PrefsKeys.role);
    } else {
      _pref.setString(PrefsKeys.role, value);
    }
  }

  // ------------------- First Time -------------------
  static bool get isFirstTime => _pref.getBool(PrefsKeys.isFirstTime) ?? true;

  static set isFirstTime(bool value) =>
      _pref.setBool(PrefsKeys.isFirstTime, value);

  // ------------------- Workshop -------------------
  static WorkshopModel? get selectedWorkShop {
    final jsonString = _pref.getString(PrefsKeys.selectedWorkShop);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return WorkshopModel.fromJson(jsonMap);
  }

  static set selectedWorkShop(WorkshopModel? value) {
    if (value == null) {
      _pref.remove(PrefsKeys.selectedWorkShop);
    } else {
      _pref.setString(PrefsKeys.selectedWorkShop, json.encode(value.toJson()));
    }
  }

  static void clearSelectedWorkShop() =>
      _pref.remove(PrefsKeys.selectedWorkShop);

  // ------------------- Attendance -------------------
  static AttendanceModel? get localeAttendance {
    final jsonString = _pref.getString(PrefsKeys.selectedAttendance);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AttendanceModel.fromJson(jsonMap);
  }

  static set localeAttendance(AttendanceModel? value) {
    print('valueeeeeee');
    print(value?.toJson());

    if (value == null) {
      print('enter null');
      _pref.remove(PrefsKeys.selectedAttendance);
    } else {
      print('cash it');

      _pref.setString(
        PrefsKeys.selectedAttendance,
        json.encode(value.toJson()),
      );
    }
  }

  ////////////////////////////////////secounds

  static void clearLocaleAttendance() =>
      _pref.remove(PrefsKeys.selectedAttendance);

  // ------------------- User -------------------
  static User? get user {
    final jsonString = _pref.getString(PrefsKeys.userInfo);
    if (jsonString == null) return null;
    return User.fromJson(jsonDecode(jsonString));
  }

  static set user(User? value) {
    if (value == null) {
      _pref.remove(PrefsKeys.userInfo);
    } else {
      _pref.setString(PrefsKeys.userInfo, jsonEncode(value.toJson()));
    }
  }

/////
  static List<AttendanceModel>? get unSyncAttendanceList {
    final jsonString =
    _pref.getString(PrefsKeys.unSyncAttendanceList);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);

    return decoded
        .map((e) => AttendanceModel.fromJson(e))
        .toList();
  }

  static set unSyncAttendanceList(
      List<AttendanceModel>? value)
  {
    if (value == null || value.isEmpty) {
      _pref.remove(PrefsKeys.unSyncAttendanceList);
    } else {
      final encoded =
      jsonEncode(value.map((e) => e.toJson()).toList());
      _pref.setString(
          PrefsKeys.unSyncAttendanceList, encoded);
    }
  }
  static void addUnSyncAttendance(
      AttendanceModel attendance)
  {
    final list = unSyncAttendanceList ?? [];

    final index =
    list.indexWhere((e) => e.id == attendance.id);

    if (index != -1) {
      list[index] = attendance; // استبدال
    } else {
      list.add(attendance); // إضافة
    }

    unSyncAttendanceList = list;
  }

  static void replaceUnSyncAttendance(
      AttendanceModel attendance)
  {
    final list = unSyncAttendanceList ?? [];

    final index =
    list.indexWhere((e) => e.id == attendance.id);

    if (index != -1) {
      list[index] = attendance;
      unSyncAttendanceList = list;
    }
  }
}

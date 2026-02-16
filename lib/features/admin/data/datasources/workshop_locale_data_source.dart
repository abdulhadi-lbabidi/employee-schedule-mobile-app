import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_all_workshop_response.dart';
import '../../../../common/helper/src/prefs_keys.dart';

import 'dart:convert';

import '../models/workshop_models/get_workshop_employees_details_response.dart';

@lazySingleton
class WorkshopLocaleDataSource {
  final SharedPreferences sharedPreferences;

  WorkshopLocaleDataSource({required this.sharedPreferences});

  /// 🔹 جلب قائمة الورش من الـ SharedPreferences
  Future<GetAllWorkshopsResponse> localeWorkShop() async {
    final jsonString = sharedPreferences.getString(PrefsKeys.localeWorkShop);

    if (jsonString == null) {
      return GetAllWorkshopsResponse(data: []);
    }

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return GetAllWorkshopsResponse.fromJson(jsonMap);
  }

  /// 🔹 حفظ قائمة الورش في الـ SharedPreferences
  Future<void> setLocaleWorkShop(
    GetAllWorkshopsResponse? localeWorkShop)
  async {
    if (localeWorkShop == null) return;

    final jsonString = json.encode(localeWorkShop.toJson());

    await sharedPreferences.setString(PrefsKeys.localeWorkShop, jsonString);
  }

  Future<GetWorkshopEmployeeDetailsResponse>
  localeWorkshopEmployeeDetails()
  async {
    final jsonString = sharedPreferences.getString(
      PrefsKeys.localeWorkshopEmployeeDetails,
    );

    if (jsonString == null) {
      return GetWorkshopEmployeeDetailsResponse(workshop: null, employees: []);
    }

    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    return GetWorkshopEmployeeDetailsResponse.fromJson(jsonMap);
  }

  Future<void> setLocaleWorkshopEmployeeDetails(
    GetWorkshopEmployeeDetailsResponse? response,
  ) async {
    if (response == null) return;

    final jsonString = json.encode(response.toJson());

    await sharedPreferences.setString(
      PrefsKeys.localeWorkshopEmployeeDetails,
      jsonString,
    );
  }
}

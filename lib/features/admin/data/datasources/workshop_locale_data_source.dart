import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/helper/src/prefs_keys.dart';
import '../../domain/entities/workshop_entity.dart';

import 'dart:convert';


@lazySingleton
class WorkshopLocaleDataSource {
  final SharedPreferences sharedPreferences;

  WorkshopLocaleDataSource({required this.sharedPreferences});

  /// 🔹 جلب قائمة الورش من الـ SharedPreferences
  Future<List<WorkshopEntity>>  localeWorkShop() async {
    final jsonString = sharedPreferences.getString(PrefsKeys.localeWorkShop);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((jsonItem) => WorkshopEntity.fromJson(jsonItem))
        .toList();
  }

  /// 🔹 حفظ قائمة الورش في الـ SharedPreferences
  Future<void> setLocaleWorkShop(List<WorkshopEntity>? localeWorkShop) async {
    if (localeWorkShop == null) return;

    final jsonList = localeWorkShop.map((e) => e.toJson()).toList();
    final jsonString = json.encode(jsonList);

    await sharedPreferences.setString(PrefsKeys.localeWorkShop, jsonString);
  }
}

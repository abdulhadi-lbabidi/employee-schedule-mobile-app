import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/get_all_loane.dart';
import '../models/loan_model.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LoanLocalDataSource {
  static const String _loansKey = "cached_loans";
  static const String _loansallKey = "cached_all_loans";

  final SharedPreferences prefs;

  LoanLocalDataSource(this.prefs);

  /// تخزين القروض
  Future<void> cacheLoans(List<LoanModel> loans) async {
    final List<Map<String, dynamic>> jsonList =
    loans.map((loan) => loan.toJson()).toList();

    final String encoded = jsonEncode(jsonList);

    await prefs.setString(_loansKey, encoded);
  }

  /// جلب كل القروض المخزنة
  List<LoanModel> getCachedLoans() {
    final String? jsonString = prefs.getString(_loansKey);

    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map((e) => LoanModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
  Future<void> cacheallLoans(List<Loane> loans) async {
    final List<Map<String, dynamic>> jsonListt =
    loans.map((loan) => loan.toJson()).toList();

    final String encoded = jsonEncode(jsonListt);

    await prefs.setString(_loansallKey, encoded);
  }

  /// جلب كل القروض المخزنة
  List<Loane> getCachedallLoans() {
    final String? jsonString = prefs.getString(_loansallKey);

    if (jsonString == null) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);

    return decoded
        .map((e) => Loane.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  /// جلب قروض موظف معين
  List<LoanModel> getCachedEmployeeLoans(int employeeId) {
    return getCachedLoans()
        .where((loan) => loan.employeeId == employeeId)
        .toList();
  }

  /// حذف الكاش
  Future<void> clearLoans() async {
    await prefs.remove(_loansKey);
  }
}


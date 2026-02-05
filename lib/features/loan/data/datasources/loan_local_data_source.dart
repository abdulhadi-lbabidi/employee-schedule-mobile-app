import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../models/get_all_loan_response.dart';
import '../models/get_loan_response.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class LoanLocalDataSource {
  static const String _loansKey = 'cached_loans';

  final SharedPreferences prefs;

  LoanLocalDataSource(this.prefs);

  /// تخزين القروض
  Future<void> cacheLoans(List<LoanModel> loans) async {
    final loansJsonList =
        loans.map((loan) => jsonEncode(loan.toJson())).toList();

    await prefs.setStringList(_loansKey, loansJsonList);
  }

  /// جلب جميع القروض المخزنة
  Future<GetAllLoansResponse> getCachedLoans() async {
    final loansJsonList = prefs.getString(_loansKey);
    if (loansJsonList == null) {
      return GetAllLoansResponse(data: []);
    }
    final Map<String, dynamic> val = json.decode(loansJsonList);

    return GetAllLoansResponse.fromJson(val);
  }

  /// جلب قروض موظف محدد
  Future<GetAllLoansResponse> getCachedEmployeeLoans(int employeeId) async {
    final val = await getCachedLoans();
    if (val.data == null) {
      return GetAllLoansResponse(data: []);
    }
    final result = val.copyWith(
      data: val.data?.where((loan) => loan.employee?.id == employeeId).toList()
    );
    return result;
  }

  /// مسح الكاش (اختياري)
  Future<void> clearLoans() async {
    await prefs.remove(_loansKey);
  }
}

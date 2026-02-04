import 'package:hive/hive.dart';
import '../models/loan_model.dart';


class LoanLocalDataSource {
  final Box<Map> loanBox;

  LoanLocalDataSource(this.loanBox);

  Future<void> cacheLoans(List<LoanModel> loans) async {
    await loanBox.clear();
    for (var loan in loans) {
      await loanBox.put(loan.id, loan.toJson());
    }
  }

  List<LoanModel> getCachedLoans() {
    return loanBox.values.map((e) => LoanModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  List<LoanModel> getCachedEmployeeLoans(String employeeId) {
    return getCachedLoans().where((loan) => loan.employeeId == employeeId).toList();
  }
}

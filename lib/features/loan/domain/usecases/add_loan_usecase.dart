import 'package:untitled8/core/unified_api/use_case.dart';
import '../../../../common/helper/src/typedef.dart';
import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddLoanUseCase {
  final LoanRepository repository;

  AddLoanUseCase(this.repository);

  DataResponse<void> call(AddLoanParams loan) async {
    return await repository.addLoan(loan);
  }
}

class AddLoanParams with Params {
  final int employeeId;
  final int adminId;
  final int amount;
  final int paidAmount;
  final String role;
  final String date;

  AddLoanParams({
    required this.employeeId,
    required this.adminId,
    required this.amount,
    required this.paidAmount,
    required this.role,
    required this.date,
  });

  @override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      'employee_id': employeeId,
      'admin_id': adminId,
      'amount': amount,
      'paid_amount': paidAmount,
      'role': role,
      'date': date,
    };
  }
}

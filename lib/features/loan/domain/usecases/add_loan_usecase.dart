import 'package:intl/intl.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
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

  final int adminId;
  final int amount;
  final int paidAmount;


  AddLoanParams({

    required this.adminId,
    required this.amount,
    required this.paidAmount,
  });

  @override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      'employee_id': AppVariables.user!.id,
      'admin_id': adminId,
      'amount': amount,
      'paid_amount': paidAmount,
      'role': AppVariables.role,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };
  }
}

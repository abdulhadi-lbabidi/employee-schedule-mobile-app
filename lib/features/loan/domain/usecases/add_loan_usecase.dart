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


  final int amount;
  final DateTime date;


  AddLoanParams({


    required this.amount,
    required this.date,
  });

  @override
  BodyMap getBody() {
    // TODO: implement getBody
    return {
      'employee_id': AppVariables.user!.id,
      'amount': amount,
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    };
  }
}

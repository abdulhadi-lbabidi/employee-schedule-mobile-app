import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../repositories/loan_repository.dart';

@injectable
class PayLoanUseCase {
  final LoanRepository repository;

  PayLoanUseCase(this.repository);

  DataResponse<void> call(int loanId, double amount) async {
    return await repository.payLoan(loanId, amount);
  }
}

import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../repositories/loan_repository.dart';

@injectable
class RejectLoanUseCase {
  final LoanRepository repository;

  RejectLoanUseCase(this.repository);

  DataResponse<void> call(int loanId) async {
    return await repository.rejectLoan(loanId);
  }
}

import 'package:injectable/injectable.dart';
import '../../../../common/helper/src/typedef.dart';
import '../repositories/loan_repository.dart';

@injectable
class ApproveLoanUseCase {
  final LoanRepository repository;

  ApproveLoanUseCase(this.repository);

  DataResponse<void> call(int loanId) async {
    return await repository.approveLoan(loanId);
  }
}

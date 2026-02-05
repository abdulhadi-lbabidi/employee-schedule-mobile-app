import '../../../../common/helper/src/typedef.dart';
import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class UpdateLoanStatusUseCase {
  final LoanRepository repository;

  UpdateLoanStatusUseCase(this.repository);

  DataResponse<void> call(int loanId, int amount) async {
    return await repository.updateLoanStatus(loanId, amount);
  }
}

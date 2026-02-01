import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class UpdateLoanStatusUseCase {
  final LoanRepository repository;

  UpdateLoanStatusUseCase(this.repository);

  Future<void> call(String loanId, LoanStatus status) async {
    return await repository.updateLoanStatus(loanId, status);
  }
}

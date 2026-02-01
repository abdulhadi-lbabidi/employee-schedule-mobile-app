import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class AddLoanUseCase {
  final LoanRepository repository;

  AddLoanUseCase(this.repository);

  Future<void> call(LoanEntity loan) async {
    return await repository.addLoan(loan);
  }
}

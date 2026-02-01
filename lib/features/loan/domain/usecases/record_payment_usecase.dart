import '../repositories/loan_repository.dart';

class RecordPaymentUseCase {
  final LoanRepository repository;

  RecordPaymentUseCase(this.repository);

  Future<void> call(String loanId, double amount) async {
    return await repository.recordPayment(loanId, amount);
  }
}

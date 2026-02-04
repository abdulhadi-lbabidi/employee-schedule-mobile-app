import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class RecordPaymentUseCase {
  final LoanRepository repository;

  RecordPaymentUseCase(this.repository);

  Future<void> call(String loanId, double amount) async {
    return await repository.recordPayment(loanId, amount);
  }
}

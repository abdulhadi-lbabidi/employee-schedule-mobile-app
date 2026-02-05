import '../../../../common/helper/src/typedef.dart';
import '../repositories/loan_repository.dart';
import 'package:injectable/injectable.dart';
@lazySingleton
class RecordPaymentUseCase {
  final LoanRepository repository;

  RecordPaymentUseCase(this.repository);

  DataResponse<void> call(int loanId, double amount) async {
    return await repository.recordPayment(loanId, amount);
  }
}

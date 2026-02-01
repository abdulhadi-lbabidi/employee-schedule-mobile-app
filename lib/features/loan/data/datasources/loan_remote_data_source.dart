import '../models/loan_model.dart';
import '../../domain/entities/loan_entity.dart';

abstract class LoanRemoteDataSource {
  Future<List<LoanModel>> getAllLoans();
  Future<List<LoanModel>> getEmployeeLoans(String employeeId);
  Future<void> addLoan(LoanModel loan);
  Future<void> updateLoanStatus(String loanId, LoanStatus status);
  Future<void> recordPayment(String loanId, double amount);
}

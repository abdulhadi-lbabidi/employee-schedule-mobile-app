import '../entities/loan_entity.dart';

abstract class LoanRepository {
  Future<List<LoanEntity>> getAllLoans();
  Future<List<LoanEntity>> getEmployeeLoans(String employeeId);
  Future<void> addLoan(LoanEntity loan);
  Future<void> updateLoanStatus(String loanId, LoanStatus status);
  Future<void> recordPayment(String loanId, double amount);
}

import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/features/loan/data/models/get_all_loan_response.dart';
import '../usecases/add_loan_usecase.dart';

abstract class LoanRepository {
  DataResponse<GetAllLoansResponse> getAllLoans();
  DataResponse<GetAllLoansResponse> getEmployeeLoans(int employeeId);
  DataResponse<void> addLoan(AddLoanParams loan);
  DataResponse<void> approveLoan(int loanId);
  DataResponse<void> rejectLoan(int loanId);
  DataResponse<void> payLoan(int loanId, double amount);
  
  @Deprecated('Use approveLoan or rejectLoan')
  DataResponse<void> updateLoanStatus(int loanId, int amount);
  @Deprecated('Use payLoan')
  DataResponse<void> recordPayment(int loanId, double amount);
}

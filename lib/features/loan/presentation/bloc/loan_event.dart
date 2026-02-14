part of 'loan_bloc.dart';

abstract class LoanEvent {
  const LoanEvent();
}

class GetAllLoansEvent extends LoanEvent {}

class GetAllEmployeeLoansEvent extends LoanEvent {
  final int employeeId;
  const GetAllEmployeeLoansEvent({required this.employeeId});
}

class AddLoanEvent extends LoanEvent {
  final AddLoanParams params;
  const AddLoanEvent({required this.params});
}

class ApproveLoanEvent extends LoanEvent {
  final int loanId;
  const ApproveLoanEvent({required this.loanId});
}

class RejectLoanEvent extends LoanEvent {
  final int loanId;
  const RejectLoanEvent({required this.loanId});
}

class PayLoanEvent extends LoanEvent {
  final int loanId;
  final double amount;
  const PayLoanEvent({required this.loanId, required this.amount});
}

@Deprecated('Use ApproveLoanEvent or RejectLoanEvent')
class UpdateLoanStatusEvent extends LoanEvent {
  final int loanId;
  final int amount;
  const UpdateLoanStatusEvent({required this.loanId, required this.amount});
}

@Deprecated('Use PayLoanEvent')
class RecordPaymentEvent extends LoanEvent {
  final int loanId;
  final double amount;
  const RecordPaymentEvent({required this.loanId, required this.amount});
}

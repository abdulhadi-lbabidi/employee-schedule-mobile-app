part of 'loan_bloc.dart';

abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllLoans extends LoanEvent {}

class LoadEmployeeLoans extends LoanEvent {
  final String employeeId;
  const LoadEmployeeLoans(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}

class AddLoan extends LoanEvent {
  final LoanEntity loan;
  const AddLoan(this.loan);

  @override
  List<Object?> get props => [loan];
}

class UpdateLoanStatus extends LoanEvent {
  final String loanId;
  final LoanStatus status;
  const UpdateLoanStatus(this.loanId, this.status);

  @override
  List<Object?> get props => [loanId, status];
}

class RecordPayment extends LoanEvent {
  final String loanId;
  final double amount;
  const RecordPayment(this.loanId, this.amount);

  @override
  List<Object?> get props => [loanId, amount];
}

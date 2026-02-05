part of 'loan_bloc.dart';

abstract class LoanEvent  {
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

class UpdateLoanStatusEvent extends LoanEvent {
  final String loanId;
  final int amount;

  const UpdateLoanStatusEvent({required this.loanId, required this.amount});

  @override
  List<Object?> get props => [loanId, amount];
}

class RecordPaymentEvent extends LoanEvent {
  final String loanId;
  final double amount;

  const RecordPaymentEvent({required this.loanId, required this.amount});


}

part of 'loan_bloc.dart';

abstract class LoanState extends Equatable {
  const LoanState();

  @override
  List<Object?> get props => [];
}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoansLoaded extends LoanState {
  final List<LoanEntity> loans;
  const LoansLoaded(this.loans);

  @override
  List<Object?> get props => [loans];
}

class LoanError extends LoanState {
  final String message;
  const LoanError(this.message);

  @override
  List<Object?> get props => [message];
}

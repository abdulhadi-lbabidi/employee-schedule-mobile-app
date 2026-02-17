import 'package:equatable/equatable.dart';

abstract class PaymentActionState extends Equatable {
  const PaymentActionState();
  @override
  List<Object?> get props => [];
}

class PaymentActionInitial extends PaymentActionState {}
class PaymentActionLoading extends PaymentActionState {}
class PaymentActionSuccess extends PaymentActionState {
  final String message;
  const PaymentActionSuccess(this.message);
}
class PaymentActionError extends PaymentActionState {
  final String errorMessage;
  const PaymentActionError(this.errorMessage);
}
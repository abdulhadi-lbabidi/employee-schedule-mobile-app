import 'package:equatable/equatable.dart';
import '../../../data/ model/get_all_payments.dart';


abstract class AllPaymentsState extends Equatable {
  const AllPaymentsState();
  @override
  List<Object?> get props => [];
}

class AllPaymentsInitial extends AllPaymentsState {}
class AllPaymentsLoading extends AllPaymentsState {}
class AllPaymentsLoaded extends AllPaymentsState {
  final List<Datum> payments;
  const AllPaymentsLoaded(this.payments);
  @override
  List<Object?> get props => [payments];
}
class AllPaymentsError extends AllPaymentsState {
  final String message;
  const AllPaymentsError(this.message);
}
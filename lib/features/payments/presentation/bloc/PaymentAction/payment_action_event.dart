import 'package:equatable/equatable.dart';
import '../../../domain/usecases/post_payrecords_params.dart';
import '../../../domain/usecases/update_payment_params.dart';

abstract class PaymentActionEvent extends Equatable {
  const PaymentActionEvent();
  @override
  List<Object?> get props => [];
}

// حدث لإرسال سجل دفع جديد
class ExecutePostPayment extends PaymentActionEvent {
  final PostPayRecordsParams params;
  const ExecutePostPayment(this.params);
}

// حدث لتعديل سجل دفع موجود
class ExecuteUpdatePayment extends PaymentActionEvent {
  final String paymentId;
  final UpdatePaymentParams params;
  const ExecuteUpdatePayment(this.paymentId, this.params);
}
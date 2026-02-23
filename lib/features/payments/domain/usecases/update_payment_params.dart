

import 'package:injectable/injectable.dart';

@injectable

class UpdatePaymentParams {
  final String paymentId;
  //final double totalAmount;
  final double amountPaid;
  final String paymentDate;

  UpdatePaymentParams({
    required this.paymentId,
   // required this.totalAmount,
    required this.amountPaid,
    required this.paymentDate,
  });

  Map<String, dynamic> toJson() {
    return {
      //"total_amount": totalAmount,
      "amount_paid": amountPaid,
      "payment_date": paymentDate,
    };
  }
}

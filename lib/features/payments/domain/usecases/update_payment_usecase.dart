import 'package:dartz/dartz.dart';
import 'package:untitled8/features/payments/domain/usecases/update_payment_params.dart';

import '../../../../core/unified_api/failures.dart';
import '../../../../core/unified_api/use_case.dart';
import '../../data/ model/put_update_payments.dart';
import '../payments_repository/paymenys_repository.dart';

class UpdatePaymentUseCase
    implements UseCase<UpdatePayments, UpdatePaymentParams> {
  final PaymenysRepository repository;

  UpdatePaymentUseCase(this.repository);

  @override
  Future<Either<Failure, UpdatePayments>> call(
      UpdatePaymentParams params) {
    return repository.putUpdatePayments(params.paymentId,params);
    // لاحقًا: repository.putUpdatePayments(params)
  }
}

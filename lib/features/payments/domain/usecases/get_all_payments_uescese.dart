import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/unified_api/failures.dart';
import '../../data/ model/dues-report.dart';
import '../../data/ model/get_all_payments.dart';
import '../payments_repository/paymenys_repository.dart';

@lazySingleton
class GetAllPaymentsUescese {
  final PaymenysRepository repository;

  GetAllPaymentsUescese(this.repository);

  Future<Either<Failure, GetAllPayments>> call() async {
    return await repository.getallpayments();
  }
}

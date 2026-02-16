import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/core/unified_api/failures.dart';
import 'package:untitled8/features/payments/data/%20model/dues-report.dart';

import '../../../../common/helper/src/typedef.dart';
import '../../domain/payments_repository/paymenys_repository.dart';
import '../datasources/payments_data_sources_impl.dart';

@LazySingleton(as: PaymenysRepository)
class PaymentsRepositoryImpl
    with HandlingException
    implements PaymenysRepository {

  final PaymentsDataSourcesImpl remote;

  PaymentsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, DuesReportModel>> getDuesReport() async =>
      wrapHandlingException(
        tryCall: () => remote.getDuesReport(),

      );
}

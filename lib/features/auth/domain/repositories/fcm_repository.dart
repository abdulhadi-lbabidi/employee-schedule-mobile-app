import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';

abstract class FcmRepository {
  Future<Either<Failure, void>> updateFcmToken(String token);
}

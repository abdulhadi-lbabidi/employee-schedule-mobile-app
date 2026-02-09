import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../../../auth/data/model/login_response.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> updatePassword(Map<String, dynamic> params);
  Future<Either<Failure, User>> updateProfileInfo(Map<String, dynamic> params);
}

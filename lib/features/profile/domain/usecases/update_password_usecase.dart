import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../../../auth/data/model/login_response.dart';
import '../repositories/profile_repository.dart';

@injectable
class UpdatePasswordUseCase {
  final ProfileRepository repository;

  UpdatePasswordUseCase(this.repository);

  Future<Either<Failure, User>> call(Map<String, dynamic> params) async {
    return await repository.updatePassword(params);
  }
}

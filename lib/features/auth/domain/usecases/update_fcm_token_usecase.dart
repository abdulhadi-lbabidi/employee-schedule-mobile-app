import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../repositories/fcm_repository.dart';

@injectable
class UpdateFcmTokenUseCase {
  final FcmRepository repository;

  UpdateFcmTokenUseCase(this.repository);

  Future<Either<Failure, void>> call(String token) async {
    return await repository.updateFcmToken(token);
  }
}

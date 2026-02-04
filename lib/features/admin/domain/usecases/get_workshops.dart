import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/workshop_entity.dart';
import '../repositories/workshop_repository.dart'; // ✅ استخدام الـ Repository الجديد

@lazySingleton
class GetWorkshopsUseCase {
  final WorkshopRepository repository; // ✅ استخدام الـ Repository الجديد

  GetWorkshopsUseCase(this.repository);

  Future<Either<Failure, List<WorkshopEntity>>> call() async {
    return repository.getWorkshops();
  }
}

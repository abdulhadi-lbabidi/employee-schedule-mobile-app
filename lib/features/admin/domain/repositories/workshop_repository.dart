import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../entities/workshop_entity.dart';

abstract class WorkshopRepository {
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops();
}

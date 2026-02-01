import 'package:dartz/dartz.dart';
import '../../../../core/unified_api/failures.dart';
import '../../../../core/unified_api/handling_exception_manager.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/repositories/workshop_repository.dart';
import '../datasources/workshop_remote_data_source.dart';
import '../models/workshop_model.dart';

class WorkshopRepositoryImpl with HandlingExceptionManager implements WorkshopRepository {
  final WorkshopRemoteDataSource remoteDataSource;

  WorkshopRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops() async {
    return wrapHandling(tryCall: () async {
      final models = await remoteDataSource.getWorkshops();
      return models.map((model) => WorkshopModel.toEntity(model)).toList();
    });
  }
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import '../../../../core/unified_api/failures.dart';
import '../../domain/entities/workshop_entity.dart';
import '../../domain/repositories/workshop_repository.dart';
import '../datasources/workshop_locale_data_source.dart';
import '../datasources/workshop_remote_data_source_impl.dart';
import '../models/workshop_model.dart';

@LazySingleton(as: WorkshopRepository)
class WorkshopRepositoryImpl
    with HandlingException
    implements WorkshopRepository {
  final WorkshopRemoteDataSource remoteDataSource;
  final WorkshopLocaleDataSource localeDataSource;

  WorkshopRepositoryImpl({
    required this.remoteDataSource,
    required this.localeDataSource,
  });

  @override
  Future<Either<Failure, List<WorkshopEntity>>> getWorkshops() async {
    return wrapHandlingException(
      tryCall: () async {
        final models = await remoteDataSource.getWorkshops();
        return models.map((model) => WorkshopModel.toEntity(model)).toList();
      },
      otherCall: () {
        return localeDataSource.localeWorkShop();
      },
    );
  }
}

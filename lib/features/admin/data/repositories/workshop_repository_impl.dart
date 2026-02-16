import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_all_workshop_response.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_workshop_employees_details_response.dart';
import '../../domain/repositories/workshop_repository.dart';
import '../../domain/usecases/add_workshop.dart';
import '../datasources/workshop_locale_data_source.dart';
import '../datasources/workshop_remote_data_source_impl.dart';

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
  DataResponse<GetWorkshopEmployeeDetailsResponse> getWorkShopEmployees(
    int id,
  ) async => await wrapHandlingException(
    tryCall: () => remoteDataSource.getWorkShopEmployees(id),
    // otherCall: ()=>localeDataSource.localeWorkshopEmployeeDetails()
  );

  @override
  DataResponse<GetAllWorkshopsResponse> getWorkshops() async =>
      await wrapHandlingException(
        tryCall: () => remoteDataSource.getWorkshops(),
        otherCall: () => localeDataSource.localeWorkShop(),
      );

  @override
  DataResponse<void> toggleWorkshopArchive(String id) async =>
      wrapHandlingException(
        tryCall: () => remoteDataSource.toggleWorkshopArchive(id),
      );

  @override
  DataResponse<void> deleteWorkshop(int id) async =>
      wrapHandlingException(tryCall: () => remoteDataSource.deleteWorkshop(id));

  @override
  DataResponse<void> addWorkshop(AddWorkshopParams params) async =>
      wrapHandlingException(
        tryCall: () => remoteDataSource.addWorkshop(params),
      );

  @override
  DataResponse<GetAllWorkshopsResponse> getArchiveWorkshops() async =>
      await wrapHandlingException(
        tryCall: () => remoteDataSource.getArchiveWorkshops(),
      );

  @override
  DataResponse<void> restoreArchivedWorkShop(String id) async =>
      wrapHandlingException(tryCall: () => remoteDataSource.restoreArchive(id));
}

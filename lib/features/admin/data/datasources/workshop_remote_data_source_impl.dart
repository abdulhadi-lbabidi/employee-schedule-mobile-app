import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/handling_api_manager.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_all_workshop_response.dart';
import '../../../../core/unified_api/api_variables.dart';
import '../../../../core/unified_api/base_api.dart';
import '../../domain/usecases/add_workshop.dart';
import '../models/workshop_models/get_workshop_employees_details_response.dart';

@lazySingleton
class WorkshopRemoteDataSource with HandlingApiManager {
  final BaseApi _baseApi;

  WorkshopRemoteDataSource({required BaseApi baseApi}) : _baseApi = baseApi;

  Future<GetAllWorkshopsResponse> getWorkshops() async => await wrapHandlingApi(
    tryCall: () => _baseApi.get(ApiVariables.workshops()),
    jsonConvert: getAllWorkshopsResponseFromJson,
  );

  Future<GetAllWorkshopsResponse> getArchiveWorkshops() async =>
      await wrapHandlingApi(
        tryCall: () => _baseApi.get(ApiVariables.workshopsArchived()),
        jsonConvert: getAllWorkshopsResponseFromJson,
      );

  Future<GetWorkshopEmployeeDetailsResponse> getWorkShopEmployees(
    int id,
  ) async => await wrapHandlingApi(
    tryCall: () => _baseApi.get(ApiVariables.workshopEmployeesDetails(id)),
    jsonConvert: getWorkshopEmployeeDetailsResponseFromJson,
  );

  Future<void> addWorkshop(
    AddWorkshopParams params,
  ) async => await wrapHandlingApi(
    tryCall:
        () => _baseApi.post(ApiVariables.addWorkshop(), data: params.getBody()),
    jsonConvert: (_) {},
  );

  Future<void> deleteWorkshop(int id) async => await wrapHandlingApi(
    tryCall: () => _baseApi.delete(ApiVariables.workshopDetails(id)),
    jsonConvert: (_) {},
  );

  Future<void> toggleWorkshopArchive(String id) async =>
      await wrapHandlingApi(
        tryCall:
            () => _baseApi.delete(
              ApiVariables.archiveWorkshop(id),
              // data: {'is_archived': isArchived},
            ),
        jsonConvert: (_) {},
      );

  Future<void> restoreArchive(String id) async =>
      await wrapHandlingApi(
        tryCall:
            () => _baseApi.post(
          ApiVariables.restoreWorkshop(id),

        ),
        jsonConvert: (_) {},
      );
}

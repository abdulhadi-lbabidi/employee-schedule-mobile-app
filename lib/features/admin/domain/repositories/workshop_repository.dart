import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_all_workshop_response.dart';
import '../../data/models/workshop_models/get_workshop_employees_details_response.dart';
import '../usecases/add_workshop.dart';

abstract class WorkshopRepository {
  DataResponse<GetAllWorkshopsResponse> getWorkshops();
  DataResponse<GetAllWorkshopsResponse> getArchiveWorkshops();
  DataResponse<GetWorkshopEmployeeDetailsResponse> getWorkShopEmployees(int id);
  DataResponse<void> addWorkshop(AddWorkshopParams params);
  DataResponse<void> deleteWorkshop(int id);
  DataResponse<void> toggleWorkshopArchive(String id);
  DataResponse<void> restoreArchivedWorkShop(String id);


}

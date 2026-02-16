import 'package:untitled8/core/data_state_model.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_all_workshop_response.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_workshop_employees_details_response.dart';

class WorkshopsState {
  final DataStateModel<GetAllWorkshopsResponse?> getAllWorkshopData;
  final DataStateModel<GetAllWorkshopsResponse?> getAllArchivedWorkshopData;
  final DataStateModel<GetWorkshopEmployeeDetailsResponse?>
  getWorkshopEmployeeDetailsData;
  final DataStateModel<void> addWorkshopData;
  final DataStateModel<void> deleteWorkshopData;
  final DataStateModel<void> toggleWorkshopArchiveData;
  final DataStateModel<void> restoreArchiveData;

  WorkshopsState({
    this.getAllWorkshopData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.restoreArchiveData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.getAllArchivedWorkshopData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.getWorkshopEmployeeDetailsData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.addWorkshopData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.deleteWorkshopData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.toggleWorkshopArchiveData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
  });

  WorkshopsState copyWith({
    DataStateModel<GetAllWorkshopsResponse?>? getAllWorkshopData,
    DataStateModel<GetAllWorkshopsResponse?>? getAllArchivedWorkshopData,
    DataStateModel<GetWorkshopEmployeeDetailsResponse?>?
    getWorkshopEmployeeDetailsData,
    DataStateModel<void>? addWorkshopData,
    DataStateModel<void>? deleteWorkshopData,
    DataStateModel<void>? toggleWorkshopArchiveData,
    DataStateModel<void>? restoreArchiveData,
  }) {
    return WorkshopsState(
      getAllWorkshopData: getAllWorkshopData ?? this.getAllWorkshopData,
      getAllArchivedWorkshopData: getAllArchivedWorkshopData ?? this.getAllArchivedWorkshopData,
      restoreArchiveData: restoreArchiveData ?? this.restoreArchiveData,
      addWorkshopData: addWorkshopData ?? this.addWorkshopData,
      toggleWorkshopArchiveData:
          toggleWorkshopArchiveData ?? this.toggleWorkshopArchiveData,
      getWorkshopEmployeeDetailsData:
          getWorkshopEmployeeDetailsData ?? this.getWorkshopEmployeeDetailsData,
      deleteWorkshopData: deleteWorkshopData ?? this.deleteWorkshopData,
    );
  }
}

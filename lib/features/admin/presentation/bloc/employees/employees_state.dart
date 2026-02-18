import 'package:untitled8/core/data_state_model.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';

class EmployeesState {
  final DataStateModel<GetAllEmployeeResponse?> employeesData;
  final DataStateModel<GetAllEmployeeResponse?> employeesArchivedData;
  final DataStateModel<void> addEmployeeData;
  final DataStateModel<void> setEmployeeArchivedData;
  final DataStateModel<void> restoreEmployeeArchivedData;

  EmployeesState({
    this.employeesData = const DataStateModel.setDefultValue(defultValue: null),
    this.employeesArchivedData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.addEmployeeData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.setEmployeeArchivedData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),
    this.restoreEmployeeArchivedData = const DataStateModel.setDefultValue(
      defultValue: null,
    ),

  });

  EmployeesState copyWith({
    DataStateModel<GetAllEmployeeResponse?>? employeesData,
    DataStateModel<GetAllEmployeeResponse?>? employeesArchivedData,
    DataStateModel<void>? setEmployeeArchivedData,
    DataStateModel<void>? addEmployeeData,
    DataStateModel<void>? restoreEmployeeArchivedData,
  }) {
    return EmployeesState(
      employeesData: employeesData ?? this.employeesData,
      restoreEmployeeArchivedData: restoreEmployeeArchivedData ?? this.restoreEmployeeArchivedData,
      addEmployeeData: addEmployeeData ?? this.addEmployeeData,
      setEmployeeArchivedData: setEmployeeArchivedData ?? this.setEmployeeArchivedData,
      employeesArchivedData:
          employeesArchivedData ?? this.employeesArchivedData,
    );
  }
}

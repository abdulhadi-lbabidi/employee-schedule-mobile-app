import '../../../domain/usecases/add_employee.dart';

abstract class EmployeesEvent {}

class LoadEmployeesEvent extends EmployeesEvent {}

class RefreshEmployeesEvent extends EmployeesEvent {}

class SearchEmployeesEvent extends EmployeesEvent {
  final String query;
  SearchEmployeesEvent(this.query);
}

class AddEmployeeEvent extends EmployeesEvent {
  final AddEmployeeParams employee;
  AddEmployeeEvent(this.employee);
}

class ToggleArchiveEmployeeEvent extends EmployeesEvent {
  final String id;
  final bool isArchived;
  ToggleArchiveEmployeeEvent(this.id, this.isArchived);
}

import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';

abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<EmployeeModel> employees;

  EmployeesLoaded(this.employees);
}

class EmployeesEmpty extends EmployeesState {}

class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError(this.message);
}

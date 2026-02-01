import '../../../domain/entities/employee_entity.dart';

abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<EmployeeEntity> employees;

  EmployeesLoaded(this.employees);
}

class EmployeesEmpty extends EmployeesState {}

class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError(this.message);
}

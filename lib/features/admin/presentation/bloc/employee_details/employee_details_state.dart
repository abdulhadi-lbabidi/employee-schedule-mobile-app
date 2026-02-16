import '../../../data/models/employee model/employee_model.dart';

abstract class EmployeeDetailsState {}

class EmployeeDetailsInitial extends EmployeeDetailsState {}

class EmployeeDetailsLoading extends EmployeeDetailsState {}

class EmployeeDetailsLoaded extends EmployeeDetailsState {
  final EmployeeModel employee;
  EmployeeDetailsLoaded(this.employee);
}

class HourlyRateUpdating extends EmployeeDetailsState {
  final EmployeeModel employee;
  HourlyRateUpdating(this.employee);
}

class HourlyRateUpdated extends EmployeeDetailsState {
  final EmployeeModel employee;
  HourlyRateUpdated(this.employee);
}

class EmployeeDetailsError extends EmployeeDetailsState {
  final String message;
  EmployeeDetailsError(this.message);
}

class EmployeeDeleted extends EmployeeDetailsState {} // 🔹 حالة جديدة

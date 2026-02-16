import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';


abstract class EmployeeDetailsEvent {}

class LoadEmployeeDetailsEvent extends EmployeeDetailsEvent {
  final String employeeId;
  LoadEmployeeDetailsEvent(this.employeeId);
}

class UpdateHourlyRateEvent extends EmployeeDetailsEvent {
  final double newRate;
  UpdateHourlyRateEvent(this.newRate);
}

class UpdateOvertimeRateEvent extends EmployeeDetailsEvent {
  final double newRate;
  UpdateOvertimeRateEvent(this.newRate);
}

class ConfirmPaymentEvent extends EmployeeDetailsEvent {
  final EmployeeModel employee;
  final int weekNumber;
  final double amountPaid;
  final bool isFullPayment;

  ConfirmPaymentEvent(this.employee, this.weekNumber, {required this.amountPaid, required this.isFullPayment});
}

class DeleteEmployeeEvent extends EmployeeDetailsEvent {
  final String employeeId;
  DeleteEmployeeEvent(this.employeeId);
}

class ToggleArchiveEmployeeDetailEvent extends EmployeeDetailsEvent {
  final String employeeId;
  final bool isArchived;
  ToggleArchiveEmployeeDetailEvent(this.employeeId, this.isArchived);
}

class UpdateEmployeeFullEvent extends EmployeeDetailsEvent {
  final String name;
  final String phoneNumber;
  final String? email;
  final String? password;
  final String? position;
  final String? department;
  final double hourlyRate;
  final double overtimeRate;
  final String? currentLocation;

  UpdateEmployeeFullEvent({
    required this.name,
    required this.phoneNumber,
    this.email,
    this.password,
    this.position,
    this.department,
    required this.hourlyRate,
    required this.overtimeRate,
    this.currentLocation,
  });
}

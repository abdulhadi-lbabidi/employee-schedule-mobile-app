import '../../../domain/entities/employee_entity.dart';

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
  final EmployeeEntity employee; 
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
  final String workshop;
  final double hourlyRate;
  final double overtimeRate;

  UpdateEmployeeFullEvent({
    required this.name,
    required this.phoneNumber,
    required this.workshop,
    required this.hourlyRate,
    required this.overtimeRate,
  });
}

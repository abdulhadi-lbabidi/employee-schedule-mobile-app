import 'package:equatable/equatable.dart';

class EmployeeSummaryEntity extends Equatable {
  final String employeeFullName;
  final List<String> workshopNames;
  final double totalRegularHours;
  final double totalOvertimeHours;
  final double regularPay;
  final double overtimePay;
  final double totalPay;
  final String currentLocation; // Added this field

  const EmployeeSummaryEntity({
    required this.employeeFullName,
    required this.workshopNames,
    required this.totalRegularHours,
    required this.totalOvertimeHours,
    required this.regularPay,
    required this.overtimePay,
    required this.totalPay,
    required this.currentLocation, // Added this field
  });

  @override
  List<Object?> get props => [
        employeeFullName,
        workshopNames,
        totalRegularHours,
        totalOvertimeHours,
        regularPay,
        overtimePay,
        totalPay,
        currentLocation, // Added this field
      ];
}

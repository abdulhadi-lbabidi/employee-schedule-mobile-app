
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';

GetWorkshopEmployeeDetailsResponse getWorkshopEmployeeDetailsResponseFromJson( str) => GetWorkshopEmployeeDetailsResponse.fromJson(str);


class GetWorkshopEmployeeDetailsResponse {
  final WorkshopModel? workshop;
  final List<EmployeeElement>? employees;

  GetWorkshopEmployeeDetailsResponse({
    this.workshop,
    this.employees,
  });

  GetWorkshopEmployeeDetailsResponse copyWith({
    WorkshopModel? workshop,
    List<EmployeeElement>? employees,
  }) =>
      GetWorkshopEmployeeDetailsResponse(
        workshop: workshop ?? this.workshop,
        employees: employees ?? this.employees,
      );

  factory GetWorkshopEmployeeDetailsResponse.fromJson(Map<String, dynamic> json) => GetWorkshopEmployeeDetailsResponse(
    workshop: json["workshop"] == null ? null : WorkshopModel.fromJson(json["workshop"]),
    employees: json["employees"] == null ? [] : List<EmployeeElement>.from(json["employees"]!.map((x) => EmployeeElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "workshop": workshop?.toJson(),
    "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
  };
}

class EmployeeElement {
  final EmployeeModel? employee;
  final double? totalRegularHours;
  final double? totalOvertimeHours;

  EmployeeElement({
    this.employee,
    this.totalRegularHours,
    this.totalOvertimeHours,
  });

  EmployeeElement copyWith({
    EmployeeModel? employee,
    double? totalRegularHours,
    double? totalOvertimeHours,
  }) =>
      EmployeeElement(
        employee: employee ?? this.employee,
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
      );

  factory EmployeeElement.fromJson(Map<String, dynamic> json) => EmployeeElement(
    employee: json["employee"] == null ? null : EmployeeModel.fromJson(json["employee"]),
    totalRegularHours: json["total_regular_hours"]?.toDouble(),
    totalOvertimeHours: json["total_overtime_hours"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "employee": employee?.toJson(),
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
  };
}



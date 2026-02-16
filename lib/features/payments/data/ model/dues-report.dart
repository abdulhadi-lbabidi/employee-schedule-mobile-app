// To parse this JSON data, do
//
//     final duesReportModel = duesReportModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DuesReportModel duesReportModelFromJson(String str) => DuesReportModel.fromJson(json.decode(str));

String duesReportModelToJson(DuesReportModel data) => json.encode(data.toJson());

class DuesReportModel {
  final Data data;
  final Summary summary;

  DuesReportModel({
    required this.data,
    required this.summary,
  });

  DuesReportModel copyWith({
    Data? data,
    Summary? summary,
  }) =>
      DuesReportModel(
        data: data ?? this.data,
        summary: summary ?? this.summary,
      );

  factory DuesReportModel.fromJson(Map<String, dynamic> json) => DuesReportModel(
    data: Data.fromJson(json["data"]),
    summary: Summary.fromJson(json["summary"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "summary": summary.toJson(),
  };
}

class Data {
  final List<Employee> employees;

  Data({
    required this.employees,
  });

  Data copyWith({
    List<Employee>? employees,
  }) =>
      Data(
        employees: employees ?? this.employees,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    employees: List<Employee>.from(json["employees"].map((x) => Employee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
  };
}

class Employee {
  final int id;
  final String fullName;
  final double totalEarned;
  final int totalPaid;
  final double remainingDue;
  final double totalHours;

  Employee({
    required this.id,
    required this.fullName,
    required this.totalEarned,
    required this.totalPaid,
    required this.remainingDue,
    required this.totalHours,
  });

  Employee copyWith({
    int? id,
    String? fullName,
    double? totalEarned,
    int? totalPaid,
    double? remainingDue,
    double? totalHours,
  }) =>
      Employee(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        totalEarned: totalEarned ?? this.totalEarned,
        totalPaid: totalPaid ?? this.totalPaid,
        remainingDue: remainingDue ?? this.remainingDue,
        totalHours: totalHours ?? this.totalHours,
      );

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    fullName: json["full_name"],
    totalEarned: json["total_earned"]?.toDouble(),
    totalPaid: json["total_paid"],
    remainingDue: json["remaining_due"]?.toDouble(),
    totalHours: json["total_hours"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "total_earned": totalEarned,
    "total_paid": totalPaid,
    "remaining_due": remainingDue,
    "total_hours": totalHours,
  };
}

class Summary {
  final int totalEmployeesCount;
  final double grandTotalDebt;

  Summary({
    required this.totalEmployeesCount,
    required this.grandTotalDebt,
  });

  Summary copyWith({
    int? totalEmployeesCount,
    double? grandTotalDebt,
  }) =>
      Summary(
        totalEmployeesCount: totalEmployeesCount ?? this.totalEmployeesCount,
        grandTotalDebt: grandTotalDebt ?? this.grandTotalDebt,
      );

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalEmployeesCount: json["total_employees_count"],
    grandTotalDebt: json["grand_total_debt"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total_employees_count": totalEmployeesCount,
    "grand_total_debt": grandTotalDebt,
  };
}

// To parse this JSON data, do
//
//     final employeeSummaryModel = employeeSummaryModelFromJson(jsonString);

import 'dart:convert';

EmployeeSummaryModel employeeSummaryModelFromJson(String str) => EmployeeSummaryModel.fromJson(json.decode(str));

String employeeSummaryModelToJson(EmployeeSummaryModel data) => json.encode(data.toJson());

class EmployeeSummaryModel {
  final Employee? employee;
  final List<WorkshopsSummary>? workshopsSummary;
  final GrandTotals? grandTotals;

  EmployeeSummaryModel({
    this.employee,
    this.workshopsSummary,
    this.grandTotals,
  });

  EmployeeSummaryModel copyWith({
    Employee? employee,
    List<WorkshopsSummary>? workshopsSummary,
    GrandTotals? grandTotals,
  }) =>
      EmployeeSummaryModel(
        employee: employee ?? this.employee,
        workshopsSummary: workshopsSummary ?? this.workshopsSummary,
        grandTotals: grandTotals ?? this.grandTotals,
      );

  factory EmployeeSummaryModel.fromJson(Map<String, dynamic> json) => EmployeeSummaryModel(
    employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    workshopsSummary: json["workshops_summary"] == null ? [] : List<WorkshopsSummary>.from(json["workshops_summary"]!.map((x) => WorkshopsSummary.fromJson(x))),
    grandTotals: json["grand_totals"] == null ? null : GrandTotals.fromJson(json["grand_totals"]),
  );

  Map<String, dynamic> toJson() => {
    "employee": employee?.toJson(),
    "workshops_summary": workshopsSummary == null ? [] : List<dynamic>.from(workshopsSummary!.map((x) => x.toJson())),
    "grand_totals": grandTotals?.toJson(),
  };
}

class Employee {
  final int? id;
  final String? position;
  final String? department;
  final int? hourlyRate;
  final int? overtimeRate;
  final bool? isOnline;
  final String? currentLocation;
  final User? user;

  Employee({
    this.id,
    this.position,
    this.department,
    this.hourlyRate,
    this.overtimeRate,
    this.isOnline,
    this.currentLocation,
    this.user,
  });

  Employee copyWith({
    int? id,
    String? position,
    String? department,
    int? hourlyRate,
    int? overtimeRate,
    bool? isOnline,
    String? currentLocation,
    User? user,
  }) =>
      Employee(
        id: id ?? this.id,
        position: position ?? this.position,
        department: department ?? this.department,
        hourlyRate: hourlyRate ?? this.hourlyRate,
        overtimeRate: overtimeRate ?? this.overtimeRate,
        isOnline: isOnline ?? this.isOnline,
        currentLocation: currentLocation ?? this.currentLocation,
        user: user ?? this.user,
      );

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    position: json["position"],
    department: json["department"],
    hourlyRate: json["hourly_rate"],
    overtimeRate: json["overtime_rate"],
    isOnline: json["is_online"],
    currentLocation: json["current_location"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "position": position,
    "department": department,
    "hourly_rate": hourlyRate,
    "overtime_rate": overtimeRate,
    "is_online": isOnline,
    "current_location": currentLocation,
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final dynamic profileImageUrl;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.profileImageUrl,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    dynamic profileImageUrl,
  }) =>
      User(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    profileImageUrl: json["profile_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "email": email,
    "profile_image_url": profileImageUrl,
  };
}

class GrandTotals {
  final int? totalRegularHours;
  final int? totalOvertimeHours;
  final int? totalRegularPay;
  final int? totalOvertimePay;
  final int? grandTotalPay;

  GrandTotals({
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.totalRegularPay,
    this.totalOvertimePay,
    this.grandTotalPay,
  });

  GrandTotals copyWith({
    int? totalRegularHours,
    int? totalOvertimeHours,
    int? totalRegularPay,
    int? totalOvertimePay,
    int? grandTotalPay,
  }) =>
      GrandTotals(
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
        totalRegularPay: totalRegularPay ?? this.totalRegularPay,
        totalOvertimePay: totalOvertimePay ?? this.totalOvertimePay,
        grandTotalPay: grandTotalPay ?? this.grandTotalPay,
      );

  factory GrandTotals.fromJson(Map<String, dynamic> json) => GrandTotals(
    totalRegularHours: json["total_regular_hours"],
    totalOvertimeHours: json["total_overtime_hours"],
    totalRegularPay: json["total_regular_pay"],
    totalOvertimePay: json["total_overtime_pay"],
    grandTotalPay: json["grand_total_pay"],
  );

  Map<String, dynamic> toJson() => {
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
    "total_regular_pay": totalRegularPay,
    "total_overtime_pay": totalOvertimePay,
    "grand_total_pay": grandTotalPay,
  };
}

class WorkshopsSummary {
  final int? workshopId;
  final String? workshopName;
  final String? location;
  final int? regularHours;
  final int? overtimeHours;
  final int? regularPay;
  final int? overtimePay;
  final int? totalPay;

  WorkshopsSummary({
    this.workshopId,
    this.workshopName,
    this.location,
    this.regularHours,
    this.overtimeHours,
    this.regularPay,
    this.overtimePay,
    this.totalPay,
  });

  WorkshopsSummary copyWith({
    int? workshopId,
    String? workshopName,
    String? location,
    int? regularHours,
    int? overtimeHours,
    int? regularPay,
    int? overtimePay,
    int? totalPay,
  }) =>
      WorkshopsSummary(
        workshopId: workshopId ?? this.workshopId,
        workshopName: workshopName ?? this.workshopName,
        location: location ?? this.location,
        regularHours: regularHours ?? this.regularHours,
        overtimeHours: overtimeHours ?? this.overtimeHours,
        regularPay: regularPay ?? this.regularPay,
        overtimePay: overtimePay ?? this.overtimePay,
        totalPay: totalPay ?? this.totalPay,
      );

  factory WorkshopsSummary.fromJson(Map<String, dynamic> json) => WorkshopsSummary(
    workshopId: json["workshop_id"],
    workshopName: json["workshop_name"],
    location: json["location"],
    regularHours: json["regular_hours"],
    overtimeHours: json["overtime_hours"],
    regularPay: json["regular_pay"],
    overtimePay: json["overtime_pay"],
    totalPay: json["total_pay"],
  );

  Map<String, dynamic> toJson() => {
    "workshop_id": workshopId,
    "workshop_name": workshopName,
    "location": location,
    "regular_hours": regularHours,
    "overtime_hours": overtimeHours,
    "regular_pay": regularPay,
    "overtime_pay": overtimePay,
    "total_pay": totalPay,
  };
}

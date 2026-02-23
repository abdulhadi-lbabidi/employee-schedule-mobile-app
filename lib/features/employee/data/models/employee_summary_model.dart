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
  final double? hourlyRate;
  final double? overtimeRate;
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

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    position: json["position"],
    department: json["department"],
    hourlyRate: (json["hourly_rate"] as num?)?.toDouble(),
    overtimeRate: (json["overtime_rate"] as num?)?.toDouble(),
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
  final double? totalRegularHours;
  final double? totalOvertimeHours;
  final double? totalRegularPay;
  final double? totalOvertimePay;
  final double? grandTotalPay;

  GrandTotals({
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.totalRegularPay,
    this.totalOvertimePay,
    this.grandTotalPay,
  });

  factory GrandTotals.fromJson(Map<String, dynamic> json) => GrandTotals(
    totalRegularHours: (json["total_regular_hours"] as num?)?.toDouble(),
    totalOvertimeHours: (json["total_overtime_hours"] as num?)?.toDouble(),
    totalRegularPay: (json["total_regular_pay"] as num?)?.toDouble(),
    totalOvertimePay: (json["total_overtime_pay"] as num?)?.toDouble(),
    grandTotalPay: (json["grand_total_pay"] as num?)?.toDouble(),
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
  final double? regularHours;
  final double? overtimeHours;
  final double? regularPay;
  final double? overtimePay;
  final double? totalPay;

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

  factory WorkshopsSummary.fromJson(Map<String, dynamic> json) => WorkshopsSummary(
    workshopId: json["workshop_id"],
    workshopName: json["workshop_name"],
    location: json["location"],
    regularHours: (json["regular_hours"] as num?)?.toDouble(),
    overtimeHours: (json["overtime_hours"] as num?)?.toDouble(),
    regularPay: (json["regular_pay"] as num?)?.toDouble(),
    overtimePay: (json["overtime_pay"] as num?)?.toDouble(),
    totalPay: (json["total_pay"] as num?)?.toDouble(),
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

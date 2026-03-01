
GetEmployeeDetailsHoursResponse getEmployeeDetailsHoursResponseFromJson( str) => GetEmployeeDetailsHoursResponse.fromJson(str);


class GetEmployeeDetailsHoursResponse {
  final int? employeeId;
  final String? fullName;
  final double? hourlyRate;
  final double? overtimeRate;
  final List<Week>? weeks;
  final Totals? grandTotals;

  GetEmployeeDetailsHoursResponse({
    this.employeeId,
    this.fullName,
    this.hourlyRate,
    this.overtimeRate,
    this.weeks,
    this.grandTotals,
  });

  GetEmployeeDetailsHoursResponse copyWith({
    int? employeeId,
    String? fullName,
    double? hourlyRate,
    double? overtimeRate,
    List<Week>? weeks,
    Totals? grandTotals,
  }) =>
      GetEmployeeDetailsHoursResponse(
        employeeId: employeeId ?? this.employeeId,
        fullName: fullName ?? this.fullName,
        hourlyRate: hourlyRate ?? this.hourlyRate,
        overtimeRate: overtimeRate ?? this.overtimeRate,
        weeks: weeks ?? this.weeks,
        grandTotals: grandTotals ?? this.grandTotals,
      );

  factory GetEmployeeDetailsHoursResponse.fromJson(Map<String, dynamic> json) => GetEmployeeDetailsHoursResponse(
    employeeId: json["employee_id"],
    fullName: json["full_name"],
    hourlyRate: (json["hourly_rate"] as num?)?.toDouble(),
    overtimeRate: (json["overtime_rate"] as num?)?.toDouble(),
    weeks: json["weeks"] == null ? [] : List<Week>.from(json["weeks"]!.map((x) => Week.fromJson(x))),
    grandTotals: json["grand_totals"] == null ? null : Totals.fromJson(json["grand_totals"]),
  );

  Map<String, dynamic> toJson() => {
    "employee_id": employeeId,
    "full_name": fullName,
    "hourly_rate": hourlyRate,
    "overtime_rate": overtimeRate,
    "weeks": weeks == null ? [] : List<dynamic>.from(weeks!.map((x) => x.toJson())),
    "grand_totals": grandTotals?.toJson(),
  };
}

class Totals {
  final double? totalRegularHours;
  final double? totalOvertimeHours;
  final double? totalRegularPay;
  final double? totalOvertimePay;
  final double? grandTotalPay;
  final List<WorkshopSummary>? workshopsSummary;

  Totals({
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.totalRegularPay,
    this.totalOvertimePay,
    this.grandTotalPay,
    this.workshopsSummary,
  });

  Totals copyWith({
    double? totalRegularHours,
    double? totalOvertimeHours,
    double? totalRegularPay,
    double? totalOvertimePay,
    double? grandTotalPay,
    List<WorkshopSummary>? workshopsSummary,
  }) =>
      Totals(
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
        totalRegularPay: totalRegularPay ?? this.totalRegularPay,
        totalOvertimePay: totalOvertimePay ?? this.totalOvertimePay,
        grandTotalPay: grandTotalPay ?? this.grandTotalPay,
        workshopsSummary: workshopsSummary ?? this.workshopsSummary,
      );

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
    totalRegularHours: json["total_regular_hours"]?.toDouble(),
    totalOvertimeHours: json["total_overtime_hours"]?.toDouble(),
    totalRegularPay: json["total_regular_pay"]?.toDouble(),
    totalOvertimePay: json["total_overtime_pay"]?.toDouble(),
    grandTotalPay: json["grand_total_pay"]?.toDouble(),
    workshopsSummary: json["workshops_summary"] == null
        ? []
        : List<WorkshopSummary>.from(
        json["workshops_summary"]!.map((x) => WorkshopSummary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
    "total_regular_pay": totalRegularPay,
    "total_overtime_pay": totalOvertimePay,
    "grand_total_pay": grandTotalPay,
    "workshops_summary": workshopsSummary == null
        ? []
        : List<dynamic>.from(workshopsSummary!.map((x) => x.toJson())),
  };
}
class WorkshopSummary {
  final WorkshopInfo? workshop;
  final double? totalRegularHours;
  final double? totalOvertimeHours;
  final double? totalRegularPay;
  final double? totalOvertimePay;
  final double? totalPay;

  WorkshopSummary({
    this.workshop,
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.totalRegularPay,
    this.totalOvertimePay,
    this.totalPay,
  });

  WorkshopSummary copyWith({
    WorkshopInfo? workshop,
    double? totalRegularHours,
    double? totalOvertimeHours,
    double? totalRegularPay,
    double? totalOvertimePay,
    double? totalPay,
  }) =>
      WorkshopSummary(
        workshop: workshop ?? this.workshop,
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
        totalRegularPay: totalRegularPay ?? this.totalRegularPay,
        totalOvertimePay: totalOvertimePay ?? this.totalOvertimePay,
        totalPay: totalPay ?? this.totalPay,
      );

  factory WorkshopSummary.fromJson(Map<String, dynamic> json) => WorkshopSummary(
    workshop: json["workshop"] == null ? null : WorkshopInfo.fromJson(json["workshop"]),
    totalRegularHours: json["total_regular_hours"]?.toDouble(),
    totalOvertimeHours: json["total_overtime_hours"]?.toDouble(),
    totalRegularPay: json["total_regular_pay"]?.toDouble(),
    totalOvertimePay: json["total_overtime_pay"]?.toDouble(),
    totalPay: json["total_pay"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "workshop": workshop?.toJson(),
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
    "total_regular_pay": totalRegularPay,
    "total_overtime_pay": totalOvertimePay,
    "total_pay": totalPay,
  };
}

class WorkshopInfo {
  final int? id;
  final String? name;
  final String? location;

  WorkshopInfo({
    this.id,
    this.name,
    this.location,
  });

  WorkshopInfo copyWith({
    int? id,
    String? name,
    String? location,
  }) =>
      WorkshopInfo(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
      );

  factory WorkshopInfo.fromJson(Map<String, dynamic> json) => WorkshopInfo(
    id: json["id"],
    name: json["name"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
  };
}
class Week {
  final String? weekRange;
  final List<WorkshopElement>? workshops;
  final Totals? weeklyTotals;

  Week({
    this.weekRange,
    this.workshops,
    this.weeklyTotals,
  });

  Week copyWith({
    String? weekRange,
    List<WorkshopElement>? workshops,
    Totals? weeklyTotals,
  }) =>
      Week(
        weekRange: weekRange ?? this.weekRange,
        workshops: workshops ?? this.workshops,
        weeklyTotals: weeklyTotals ?? this.weeklyTotals,
      );

  factory Week.fromJson(Map<String, dynamic> json) => Week(
    weekRange: json["week_range"],
    workshops: json["workshops"] == null ? [] : List<WorkshopElement>.from(json["workshops"]!.map((x) => WorkshopElement.fromJson(x))),
    weeklyTotals: json["weekly_totals"] == null ? null : Totals.fromJson(json["weekly_totals"]),
  );

  Map<String, dynamic> toJson() => {
    "week_range": weekRange,
    "workshops": workshops == null ? [] : List<dynamic>.from(workshops!.map((x) => x.toJson())),
    "weekly_totals": weeklyTotals?.toJson(),
  };
}

class WorkshopElement {
  final WorkshopWorkshop? workshop;
  final double? totalRegularHours;
  final double? totalOvertimeHours;
  final double? regularPay;
  final double? overtimePay;
  final double? totalPay;

  WorkshopElement({
    this.workshop,
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.regularPay,
    this.overtimePay,
    this.totalPay,
  });

  WorkshopElement copyWith({
    WorkshopWorkshop? workshop,
    double? totalRegularHours,
    double? totalOvertimeHours,
    double? regularPay,
    double? overtimePay,
    double? totalPay,
  }) =>
      WorkshopElement(
        workshop: workshop ?? this.workshop,
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
        regularPay: regularPay ?? this.regularPay,
        overtimePay: overtimePay ?? this.overtimePay,
        totalPay: totalPay ?? this.totalPay,
      );

  factory WorkshopElement.fromJson(Map<String, dynamic> json) => WorkshopElement(
    workshop: json["workshop"] == null ? null : WorkshopWorkshop.fromJson(json["workshop"]),
    totalRegularHours: json["total_regular_hours"]?.toDouble(),
    totalOvertimeHours: json["total_overtime_hours"]?.toDouble(),
    regularPay: json["regular_pay"]?.toDouble(),
    overtimePay: json["overtime_pay"]?.toDouble(),
    totalPay: json["total_pay"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "workshop": workshop?.toJson(),
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
    "regular_pay": regularPay,
    "overtime_pay": overtimePay,
    "total_pay": totalPay,
  };
}

class WorkshopWorkshop {
  final int? id;
  final String? name;
  final String? location;

  WorkshopWorkshop({
    this.id,
    this.name,
    this.location,
  });

  WorkshopWorkshop copyWith({
    int? id,
    String? name,
    String? location,
  }) =>
      WorkshopWorkshop(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
      );

  factory WorkshopWorkshop.fromJson(Map<String, dynamic> json) => WorkshopWorkshop(
    id: json["id"],
    name: json["name"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
  };
}

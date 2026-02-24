import 'dart:convert';

GetDashboardData getDashboardDataFromJson(String str) => GetDashboardData.fromJson(json.decode(str));

String getDashboardDataToJson(GetDashboardData data) => json.encode(data.toJson());

class GetDashboardData {
  final String? monthName;
  final GeneralCounts? generalCounts;
  final SStats? rewardsStats;
  final SStats? loansStats;
  final AttendanceEarnings? attendanceEarnings;

  GetDashboardData({
    this.monthName,
    this.generalCounts,
    this.rewardsStats,
    this.loansStats,
    this.attendanceEarnings,
  });

  factory GetDashboardData.fromJson(Map<String, dynamic> json) => GetDashboardData(
    monthName: json["month_name"],
    generalCounts: json["general_counts"] == null ? null : GeneralCounts.fromJson(json["general_counts"]),
    rewardsStats: json["rewards_stats"] == null ? null : SStats.fromJson(json["rewards_stats"]),
    loansStats: json["loans_stats"] == null ? null : SStats.fromJson(json["loans_stats"]),
    attendanceEarnings: json["attendance_earnings"] == null ? null : AttendanceEarnings.fromJson(json["attendance_earnings"]),
  );

  Map<String, dynamic> toJson() => {
    "month_name": monthName,
    "general_counts": generalCounts?.toJson(),
    "rewards_stats": rewardsStats?.toJson(),
    "loans_stats": loansStats?.toJson(),
    "attendance_earnings": attendanceEarnings?.toJson(),
  };
}

class AttendanceEarnings {
  final double? totalEstimatedAmount;
  final double? regularHours;
  final double? overtimeHours;

  AttendanceEarnings({
    this.totalEstimatedAmount,
    this.regularHours,
    this.overtimeHours,
  });

  factory AttendanceEarnings.fromJson(Map<String, dynamic> json) => AttendanceEarnings(
    totalEstimatedAmount: (json["total_estimated_amount"] as num?)?.toDouble(),
    regularHours: (json["regular_hours"] as num?)?.toDouble(),
    overtimeHours: (json["overtime_hours"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total_estimated_amount": totalEstimatedAmount,
    "regular_hours": regularHours,
    "overtime_hours": overtimeHours,
  };
}

class GeneralCounts {
  final int? totalEmployees;
  final int? totalWorkshops;

  GeneralCounts({
    this.totalEmployees,
    this.totalWorkshops,
  });

  factory GeneralCounts.fromJson(Map<String, dynamic> json) => GeneralCounts(
    totalEmployees: json["total_employees"],
    totalWorkshops: json["total_workshops"],
  );

  Map<String, dynamic> toJson() => {
    "total_employees": totalEmployees,
    "total_workshops": totalWorkshops,
  };
}

class SStats {
  final int? count;
  final double? totalAmount;

  SStats({
    this.count,
    this.totalAmount,
  });

  factory SStats.fromJson(Map<String, dynamic> json) => SStats(
    count: json["count"],
    totalAmount: (json["total_amount"] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "total_amount": totalAmount,
  };
}

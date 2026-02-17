// To parse this JSON data, do
//
//     final unpaidWeeks = unpaidWeeksFromJson(jsonString);

import 'dart:convert';

List<UnpaidWeeks> unpaidWeeksFromJson(String str) => List<UnpaidWeeks>.from(json.decode(str).map((x) => UnpaidWeeks.fromJson(x)));

String unpaidWeeksToJson(List<UnpaidWeeks> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnpaidWeeks {
  final String? weekRange;
  final double? totalRegularHours;
  final double? totalOvertimeHours;
  final double? estimatedAmount;
  final int? daysCount;
  final List<int>? ids;

  UnpaidWeeks({
    this.weekRange,
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.estimatedAmount,
    this.daysCount,
    this.ids,
  });

  UnpaidWeeks copyWith({
    String? weekRange,
    double? totalRegularHours,
    double? totalOvertimeHours,
    double? estimatedAmount,
    int? daysCount,
    List<int>? ids,
  }) =>
      UnpaidWeeks(
        weekRange: weekRange ?? this.weekRange,
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
        estimatedAmount: estimatedAmount ?? this.estimatedAmount,
        daysCount: daysCount ?? this.daysCount,
        ids: ids ?? this.ids,
      );

  factory UnpaidWeeks.fromJson(Map<String, dynamic> json) => UnpaidWeeks(
    weekRange: json["week_range"],
    totalRegularHours: json["total_regular_hours"]?.toDouble(),
    totalOvertimeHours: json["total_overtime_hours"]?.toDouble(),
    estimatedAmount: json["estimated_amount"]?.toDouble(),
    daysCount: json["days_count"],
    ids: json["ids"] == null ? [] : List<int>.from(json["ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "week_range": weekRange,
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
    "estimated_amount": estimatedAmount,
    "days_count": daysCount,
    "ids": ids == null ? [] : List<dynamic>.from(ids!.map((x) => x)),
  };
}

import 'dart:convert';

UnpaidWeeksResponse unpaidWeeksResponseFromJson(String str) => UnpaidWeeksResponse.fromJson(json.decode(str));

class UnpaidWeeksResponse {
  final List<UnpaidWeeks> weeks;
  final PaymentSummary? summary;

  UnpaidWeeksResponse({
    required this.weeks,
    this.summary,
  });

  factory UnpaidWeeksResponse.fromJson(Map<String, dynamic> json) => UnpaidWeeksResponse(
    weeks: json["weeks"] == null ? [] : List<UnpaidWeeks>.from(json["weeks"]!.map((x) => UnpaidWeeks.fromJson(x))),
    summary: json["summary"] == null ? null : PaymentSummary.fromJson(json["summary"]),
  );
}

class UnpaidWeeks {
  final String? weekRange;
  final double? totalRegularHours;
  final double? totalOvertimeHours;
  final double? estimatedAmount;
  final int? daysCount;
  final List<int>? ids;
  final String? status;

  UnpaidWeeks({
    this.weekRange,
    this.totalRegularHours,
    this.totalOvertimeHours,
    this.estimatedAmount,
    this.daysCount,
    this.ids,
    this.status,
  });

  factory UnpaidWeeks.fromJson(Map<String, dynamic> json) => UnpaidWeeks(
    weekRange: json["week_range"],
    totalRegularHours: (json["total_regular_hours"] as num?)?.toDouble(),
    totalOvertimeHours: (json["total_overtime_hours"] as num?)?.toDouble(),
    estimatedAmount: (json["estimated_amount"] as num?)?.toDouble(),
    daysCount: json["days_count"],
    ids: json["ids"] == null ? [] : List<int>.from(json["ids"]!.map((x) => x)),
    status: json["payment_status"],
  );
}

class PaymentSummary {
  final double? grossTotal;
  final double? discounts;
  final double? netTotal;

  PaymentSummary({
    this.grossTotal,
    this.discounts,
    this.netTotal,
  });

  factory PaymentSummary.fromJson(Map<String, dynamic> json) => PaymentSummary(
    grossTotal: (json["gross_total"] as num?)?.toDouble(),
    discounts: (json["discounts"] as num?)?.toDouble(),
    netTotal: (json["net_total"] as num?)?.toDouble(),
  );
}

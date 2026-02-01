import '../../domain/entities/finance_entity.dart';

class FinanceWeekModel extends FinanceWeekEntity {
  const FinanceWeekModel({
    required super.weekNumber,
    required super.isPaid,
    required super.regularHours,
    required super.overtimeHours,
    required super.workshops,
    required super.hourlyRate,
    required super.overtimeRate,
  });

  factory FinanceWeekModel.fromJson(Map<String, dynamic> json) {
    return FinanceWeekModel(
      weekNumber: json['week'] ?? 0,
      isPaid: json['is_paid'] ?? json['isPaid'] ?? false,
      regularHours: (json['reg_hours'] ?? json['regHours'] ?? 0).toDouble(),
      overtimeHours: (json['ot_hours'] ?? json['otHours'] ?? 0).toDouble(),
      workshops: List<String>.from(json['workshops'] ?? []),
      hourlyRate: (json['hourly_rate'] ?? 3000.0).toDouble(),
      overtimeRate: (json['overtime_rate'] ?? 4500.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'week': weekNumber,
      'is_paid': isPaid,
      'reg_hours': regularHours,
      'ot_hours': overtimeHours,
      'workshops': workshops,
      'hourly_rate': hourlyRate,
      'overtime_rate': overtimeRate,
    };
  }
}

import 'package:untitled8/features/reward/domain/entities/reward_entity.dart';

class RewardModel extends RewardEntity {
  const RewardModel({
    required String id,
    required String employeeId,
    required String employeeName,
    required String adminId,
    required String adminName,
    required double amount,
    required String reason,
    required DateTime dateIssued,
  }) : super(
          id: id,
          employeeId: employeeId,
          employeeName: employeeName,
          adminId: adminId,
          adminName: adminName,
          amount: amount,
          reason: reason,
          dateIssued: dateIssued,
        );

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String,
      adminId: json['admin_id'] as String,
      adminName: json['admin_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      reason: json['reason'] as String,
      dateIssued: DateTime.parse(json['date_issued'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'admin_id': adminId,
      'admin_name': adminName,
      'amount': amount,
      'reason': reason,
      'date_issued': dateIssued.toIso8601String(),
    };
  }

  // Convert entity to model for convenience if needed for database operations
  factory RewardModel.fromEntity(RewardEntity entity) {
    return RewardModel(
      id: entity.id,
      employeeId: entity.employeeId,
      employeeName: entity.employeeName,
      adminId: entity.adminId,
      adminName: entity.adminName,
      amount: entity.amount,
      reason: entity.reason,
      dateIssued: entity.dateIssued,
    );
  }
}

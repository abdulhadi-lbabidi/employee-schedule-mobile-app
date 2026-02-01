import 'package:equatable/equatable.dart';

class RewardEntity extends Equatable {
  final String id;
  final String employeeId;
  final String employeeName;
  final String adminId;
  final String adminName;
  final double amount;
  final String reason;
  final DateTime dateIssued;

  const RewardEntity({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.adminId,
    required this.adminName,
    required this.amount,
    required this.reason,
    required this.dateIssued,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        employeeName,
        adminId,
        adminName,
        amount,
        reason,
        dateIssued,
      ];

  RewardEntity copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    String? adminId,
    String? adminName,
    double? amount,
    String? reason,
    DateTime? dateIssued,
  }) {
    return RewardEntity(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      adminId: adminId ?? this.adminId,
      adminName: adminName ?? this.adminName,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      dateIssued: dateIssued ?? this.dateIssued,
    );
  }
}

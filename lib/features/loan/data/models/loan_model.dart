import '../../domain/entities/loan_entity.dart';

class LoanModel extends LoanEntity {
  const LoanModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.amount,
    required super.paidAmount,
    required super.reason,
    required super.date,
    required super.status,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidAmount: (json['paidAmount'] as num).toDouble(),
      reason: json['reason'] as String,
      date: DateTime.parse(json['date'] as String),
      status: LoanStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => LoanStatus.unpaid,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'amount': amount,
      'paidAmount': paidAmount,
      'reason': reason,
      'date': date.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }

  factory LoanModel.fromEntity(LoanEntity entity) {
    return LoanModel(
      id: entity.id,
      employeeId: entity.employeeId,
      employeeName: entity.employeeName,
      amount: entity.amount,
      paidAmount: entity.paidAmount,
      reason: entity.reason,
      date: entity.date,
      status: entity.status,
    );
  }
}

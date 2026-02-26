import 'package:equatable/equatable.dart';

class PenaltyEntity extends Equatable {
  final int id;
  final double amount;
  final String reason;
  final DateTime dateIssued;
  final String employeeName;
  final String? adminName;
  final String? workshopName; // 🔹 إضافة اسم الورشة

  const PenaltyEntity({
    required this.id,
    required this.amount,
    required this.reason,
    required this.dateIssued,
    required this.employeeName,
    this.adminName,
    this.workshopName,
  });

  @override
  List<Object?> get props => [id, amount, reason, dateIssued, employeeName, adminName, workshopName];
}

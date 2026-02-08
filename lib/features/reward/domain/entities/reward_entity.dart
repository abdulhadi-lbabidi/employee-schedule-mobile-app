import 'package:equatable/equatable.dart';

class RewardEntity extends Equatable {
  final int id;
  final double amount;
  final String reason;
  final DateTime dateIssued;
  final String? adminName;
  final String employeeName; // Added this field

  const RewardEntity({
    required this.id,
    required this.amount,
    required this.reason,
    required this.dateIssued,
    required this.employeeName, // Added this field
    this.adminName,
  });

  @override
  List<Object?> get props => [id, amount, reason, dateIssued, adminName, employeeName];
}

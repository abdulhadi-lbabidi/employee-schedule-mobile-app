import 'package:equatable/equatable.dart';

enum LoanStatus { unpaid, partiallyPaid, fullyPaid }

class LoanEntity extends Equatable {
  final int id;
  final int employeeId;
  final String employeeName;
  final double amount;
  final double paidAmount;
  final DateTime date;
  final LoanStatus role;

  const LoanEntity({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    required this.paidAmount,
    required this.date,
    required this.role,
  });

  @override
  List<Object?> get props => [id, employeeId, employeeName, amount, paidAmount, date, role];
}

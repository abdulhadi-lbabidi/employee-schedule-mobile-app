// import 'package:equatable/equatable.dart';
//
// enum LoanStatus { unpaid, partiallyPaid, fullyPaid }
//
// class LoanEntity extends Equatable {
//   final String id;
//   final String employeeId;
//   final String employeeName;
//   final double amount;
//   final double paidAmount;
//   final String reason;
//   final DateTime date;
//   final LoanStatus status;
//
//   const LoanEntity({
//     required this.id,
//     required this.employeeId,
//     required this.employeeName,
//     required this.amount,
//     required this.paidAmount,
//     required this.reason,
//     required this.date,
//     required this.status,
//   });
//
//   double get remainingAmount => amount - paidAmount;
//
//   @override
//   List<Object?> get props => [id, employeeId, employeeName, amount, paidAmount, reason, date, status];
//
//   LoanEntity copyWith({
//     String? id,
//     String? employeeId,
//     String? employeeName,
//     double? amount,
//     double? paidAmount,
//     String? reason,
//     DateTime? date,
//     LoanStatus? status,
//   }) {
//     return LoanEntity(
//       id: id ?? this.id,
//       employeeId: employeeId ?? this.employeeId,
//       employeeName: employeeName ?? this.employeeName,
//       amount: amount ?? this.amount,
//       paidAmount: paidAmount ?? this.paidAmount,
//       reason: reason ?? this.reason,
//       date: date ?? this.date,
//       status: status ?? this.status,
//     );
//   }
// }

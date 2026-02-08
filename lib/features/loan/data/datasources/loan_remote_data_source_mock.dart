// import '../../domain/entities/loan_entity.dart';
// import '../models/get_loan_response.dart';
// import 'package:injectable/injectable.dart';
// @lazySingleton
// class LoanRemoteDataSourceMock {
//   final List<LoanModel> _mockLoans = [
//     LoanModel(
//       id: '1',
//       employeeId: 'emp1',
//       employeeName: 'علي',
//       amount: 50000,
//       paidAmount: 20000,
//       reason: 'سلفة زواج',
//       date: DateTime.now().subtract(const Duration(days: 10)),
//       status: LoanStatus.partiallyPaid,
//     ),
//     LoanModel(
//       id: '2',
//       employeeId: 'emp2',
//       employeeName: 'سارة ',
//       amount: 30000,
//       paidAmount: 0,
//       reason: 'تصليح سيارة',
//       date: DateTime.now().subtract(const Duration(days: 5)),
//       status: LoanStatus.unpaid,
//     ),
//   ];
//
//   @override
//   Future<List<LoanModel>> getAllLoans() async {
//     await Future.delayed(const Duration(seconds: 1));
//     return _mockLoans;
//   }
//
//   @override
//   Future<List<LoanModel>> getEmployeeLoans(String employeeId) async {
//     await Future.delayed(const Duration(seconds: 1));
//     return _mockLoans.where((loan) => loan.employeeId == employeeId).toList();
//   }
//
//   @override
//   Future<void> addLoan(LoanModel loan) async {
//     await Future.delayed(const Duration(seconds: 1));
//     _mockLoans.add(loan);
//   }
//
//   @override
//   Future<void> updateLoanStatus(String loanId, LoanStatus status) async {
//     await Future.delayed(const Duration(seconds: 1));
//     final index = _mockLoans.indexWhere((l) => l.id == loanId);
//     if (index != -1) {
//       _mockLoans[index] = LoanModel.fromEntity(_mockLoans[index].copyWith(status: status));
//     }
//   }
//
//   @override
//   Future<void> recordPayment(String loanId, double amount) async {
//     await Future.delayed(const Duration(seconds: 1));
//     final index = _mockLoans.indexWhere((l) => l.id == loanId);
//     if (index != -1) {
//       final currentPaid = _mockLoans[index].paidAmount;
//       final newPaid = currentPaid + amount;
//       LoanStatus newStatus = _mockLoans[index].status;
//       if (newPaid >= _mockLoans[index].amount) {
//         newStatus = LoanStatus.fullyPaid;
//       } else if (newPaid > 0) {
//         newStatus = LoanStatus.partiallyPaid;
//       }
//       _mockLoans[index] = LoanModel.fromEntity(_mockLoans[index].copyWith(
//         paidAmount: newPaid,
//         status: newStatus,
//       ));
//     }
//   }
// }

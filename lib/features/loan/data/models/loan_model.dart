import 'package:intl/intl.dart';
import '../../domain/entities/loan_entity.dart';

class LoanModel extends LoanEntity {
  final AdminModel? employeeModel;

  const LoanModel({
    required super.id,
    required super.employeeId,
    required super.employeeName,
    required super.amount,
    required super.paidAmount,
    required super.date,
    required super.role,
    this.employeeModel,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    final employeeJson = json['employee'];
    
    DateTime parseDate(dynamic dateStr) {
      if (dateStr == null) return DateTime.now();
      String s = dateStr.toString();
      try {
        return DateTime.parse(s);
      } catch (e) {
        try {
          return DateFormat('dd-MM-yyyy').parse(s);
        } catch (e) {
          return DateTime.now();
        }
      }
    }

    return LoanModel(
      id: json['id'] as int? ?? 0,
      employeeId: employeeJson != null ? employeeJson['id'] as int? ?? 0 : 0,
      employeeName: employeeJson != null ? employeeJson['full_name'] as String? ?? "Unknown" : "Unknown",
      amount: (json['amount'] as num? ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] as num? ?? 0).toDouble(),
      date: parseDate(json['date']),
      role: _parseStatus(json['role']?.toString()),
      employeeModel: employeeJson != null ? AdminModel.fromJson(employeeJson) : null,
    );
  }

  static LoanStatus _parseStatus(String? status) {
    switch (status) {
      case 'paid':
      case 'fullyPaid':
        return LoanStatus.fullyPaid;
      case 'partially_paid':
      case 'partiallyPaid':
        return LoanStatus.partiallyPaid;
      default:
        return LoanStatus.unpaid;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'paid_amount': paidAmount,
      'date': date.toIso8601String(),
      'role': role.name,
      'employee_id': employeeId,
    };
  }
}

class AdminModel {
  final int? id;
  final String? fullName;
  final String? phoneNumber;

  AdminModel({this.id, this.fullName, this.phoneNumber});

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
  };
}

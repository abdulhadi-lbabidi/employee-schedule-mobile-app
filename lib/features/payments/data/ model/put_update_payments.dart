// To parse this JSON data, do
//
//     final updatePayments = updatePaymentsFromJson(jsonString);

import 'dart:convert';

UpdatePayments updatePaymentsFromJson(String str) => UpdatePayments.fromJson(json.decode(str));

String updatePaymentsToJson(UpdatePayments data) => json.encode(data.toJson());

class UpdatePayments {
  final Data? data;

  UpdatePayments({
    this.data,
  });

  UpdatePayments copyWith({
    Data? data,
  }) =>
      UpdatePayments(
        data: data ?? this.data,
      );

  factory UpdatePayments.fromJson(Map<String, dynamic> json) => UpdatePayments(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}

class Data {
  final int? id;
  final String? employeeName;
  final String? adminName;
  final int? totalAmount;
  final double? amountPaid;
  final double? remainingAmount;
  final String? status;
  final String? paymentDate;

  Data({
    this.id,
    this.employeeName,
    this.adminName,
    this.totalAmount,
    this.amountPaid,
    this.remainingAmount,
    this.status,
    this.paymentDate,
  });

  Data copyWith({
    int? id,
    String? employeeName,
    String? adminName,
    int? totalAmount,
    double? amountPaid,
    double? remainingAmount,
    String? status,
    String? paymentDate,
  }) =>
      Data(
        id: id ?? this.id,
        employeeName: employeeName ?? this.employeeName,
        adminName: adminName ?? this.adminName,
        totalAmount: totalAmount ?? this.totalAmount,
        amountPaid: amountPaid ?? this.amountPaid,
        remainingAmount: remainingAmount ?? this.remainingAmount,
        status: status ?? this.status,
        paymentDate: paymentDate ?? this.paymentDate,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    employeeName: json["employee_name"],
    adminName: json["admin_name"],
    totalAmount: json["total_amount"],
    amountPaid: json["amount_paid"]?.toDouble(),
    remainingAmount: json["remaining_amount"]?.toDouble(),
    status: json["status"],
    paymentDate: json["payment_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_name": employeeName,
    "admin_name": adminName,
    "total_amount": totalAmount,
    "amount_paid": amountPaid,
    "remaining_amount": remainingAmount,
    "status": status,
    "payment_date": paymentDate,
  };
}

import 'dart:convert';

GetAllPayments getAllPaymentsFromJson(String str) => GetAllPayments.fromJson(json.decode(str));

String getAllPaymentsToJson(GetAllPayments data) => json.encode(data.toJson());

class GetAllPayments {
  final List<Datum>? data;

  GetAllPayments({this.data});

  factory GetAllPayments.fromJson(Map<String, dynamic> json) => GetAllPayments(
    data: json["data"] == null
        ? []
        : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? employeeName;
  final String? adminName;
  final double? totalAmount;
  final double? amountPaid;
  final double? remainingAmount;
  final String? status;
  final String? paymentDate;

  Datum({
    this.id,
    this.employeeName,
    this.adminName,
    this.totalAmount,
    this.amountPaid,
    this.remainingAmount,
    this.status,
    this.paymentDate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    // معالجة مرنة إذا كان الاسم يأتي كنص أو كخريطة (Object)
    employeeName: json["employee_name"] is Map
        ? json["employee_name"]["name"]?.toString()
        : json["employee_name"]?.toString(),
    adminName: json["admin_name"] is Map
        ? json["admin_name"]["name"]?.toString()
        : json["admin_name"]?.toString(),
    totalAmount: json["total_amount"]?.toDouble(),
    amountPaid: json["amount_paid"]?.toDouble(),
    remainingAmount: json["remaining_amount"]?.toDouble(),
    status: json["status"]?.toString(),
    paymentDate: json["payment_date"]?.toString(),
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
import 'dart:convert';

/// ===============================
/// JSON Helpers
/// ===============================
GetAllLoane getAllLoaneFromJson(String str) =>
    GetAllLoane.fromJson(json.decode(str));

String getAllLoaneToJson(GetAllLoane data) =>
    json.encode(data.toJson());

/// ===============================
/// Root Response
/// ===============================
class GetAllLoane {
  final List<Loane> data;

  GetAllLoane({required this.data});

  factory GetAllLoane.fromJson(Map<String, dynamic> json) => GetAllLoane(
    data: json["data"] == null
        ? []
        : List<Loane>.from(
      json["data"].map((x) => Loane.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "data": data.map((x) => x.toJson()).toList(),
  };
}

/// ===============================
/// Loan Model (API Model)
/// ===============================
class Loane {
  final int id;
  final double amount;
  final double paidAmount;
  final LoanStatus status;
  final DateTime date;
  final Employee employee;

  Loane({
    required this.id,
    required this.amount,
    required this.paidAmount,
    required this.status,
    required this.date,
    required this.employee,
  });

  factory Loane.fromJson(Map<String, dynamic> json) => Loane(
    id: json["id"],
    amount: (json["amount"] ?? 0).toDouble(),
    paidAmount: (json["paid_amount"] ?? 0).toDouble(),
    status: LoanStatusExtension.fromString(json["status"]),
    date: _parseDate(json["date"]),
    employee: Employee.fromJson(json["employee"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "paid_amount": paidAmount,
    "status": status.toApi(),
    "date": _formatDate(date),
    "employee": employee.toJson(),
  };

  /// API يرجع dd-MM-yyyy
  static DateTime _parseDate(String date) {
    final parts = date.split("-");
    return DateTime(
      int.parse(parts[2]),
      int.parse(parts[1]),
      int.parse(parts[0]),
    );
  }

  /// نرجع التاريخ بنفس صيغة الـ API
  static String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }
}

/// ===============================
/// Employee Model
/// ===============================
class Employee {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String? email;

  Employee({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "email": email,
  };
}

/// ===============================
/// Loan Status Enum (صح 👌)
/// ===============================
enum LoanStatus {
  approved,
  completed,
  partially,
  rejected,
  waiting,
}

extension LoanStatusExtension on LoanStatus {
  static LoanStatus fromString(String value) {
    switch (value) {
      case "approved":
        return LoanStatus.approved;
      case "completed":
        return LoanStatus.completed;
      case "partially":
        return LoanStatus.partially;
      case "rejected":
        return LoanStatus.rejected;
      default:
        return LoanStatus.waiting;
    }
  }

  String toApi() {
    return name;
  }
}

GetLoanResponse getLoanResponseFromJson( str) => GetLoanResponse.fromJson(str);


class GetLoanResponse {
  final LoanModel? data;

  GetLoanResponse({
    this.data,
  });

  GetLoanResponse copyWith({
    LoanModel? data,
  }) =>
      GetLoanResponse(
        data: data ?? this.data,
      );

  factory GetLoanResponse.fromJson(Map<String, dynamic> json) => GetLoanResponse(
    data: json["data"] == null ? null : LoanModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}



class LoanModel {
  final int? id;
  final int? amount;
  final int? paidAmount;
  final String? role;
  final DateTime? date;
  final Admin? employee;
  final Admin? admin;

  LoanModel({
    this.id,
    this.amount,
    this.paidAmount,
    this.role,
    this.date,
    this.employee,
    this.admin,
  });

  LoanModel copyWith({
    int? id,
    int? amount,
    int? paidAmount,
    String? role,
    DateTime? date,
    Admin? employee,
    Admin? admin,
  }) => LoanModel(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    paidAmount: paidAmount ?? this.paidAmount,
    role: role ?? this.role,
    date: date ?? this.date,
    employee: employee ?? this.employee,
    admin: admin ?? this.admin,
  );

  factory LoanModel.fromJson(Map<String, dynamic> json) => LoanModel(
    id: json["id"],
    amount: json["amount"],
    paidAmount: json["paid_amount"],
    role: json["role"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    employee:
        json["employee"] == null ? null : Admin.fromJson(json["employee"]),
    admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "paid_amount": paidAmount,
    "role": role,
    "date": date?.toIso8601String(),
    "employee": employee?.toJson(),
    "admin": admin?.toJson(),
  };
}

class Admin {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final dynamic email;

  Admin({this.id, this.fullName, this.phoneNumber, this.email});

  Admin copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    dynamic email,
  }) => Admin(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    email: email ?? this.email,
  );

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
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

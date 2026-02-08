import 'loan_model.dart';

GetLoanResponse getLoanResponseFromJson(str) => GetLoanResponse.fromJson(str);

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

class Admin {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final dynamic email;

  Admin({this.id, this.fullName, this.phoneNumber, this.email});

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

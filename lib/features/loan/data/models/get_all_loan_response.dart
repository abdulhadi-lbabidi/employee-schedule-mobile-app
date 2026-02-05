
import 'get_loan_response.dart';

GetAllLoansResponse getAllLoansResponseFromJson( str) => GetAllLoansResponse.fromJson(str);


class GetAllLoansResponse {
  final List<LoanModel>? data;

  GetAllLoansResponse({
    this.data,
  });

  GetAllLoansResponse copyWith({
    List<LoanModel>? data,
  }) =>
      GetAllLoansResponse(
        data: data ?? this.data,
      );

  factory GetAllLoansResponse.fromJson(Map<String, dynamic> json) => GetAllLoansResponse(
    data: json["data"] == null ? [] : List<LoanModel>.from(json["data"]!.map((x) => LoanModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}


import 'employee_model.dart';

GetEmployeeResponse getEmployeeResponseFromJson(str) => GetEmployeeResponse.fromJson(str);


class GetEmployeeResponse {
  final EmployeeModel? data;

  GetEmployeeResponse({
    this.data,
  });

  GetEmployeeResponse copyWith({
    EmployeeModel? data,
  }) =>
      GetEmployeeResponse(
        data: data ?? this.data,
      );

  factory GetEmployeeResponse.fromJson(Map<String, dynamic> json) => GetEmployeeResponse(
    data: json["data"] == null ? null : EmployeeModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
  };
}


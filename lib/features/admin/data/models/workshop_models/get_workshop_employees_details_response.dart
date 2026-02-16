
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';

GetWorkshopEmployeeDetailsResponse getWorkshopEmployeeDetailsResponseFromJson( str) => GetWorkshopEmployeeDetailsResponse.fromJson(str);


class GetWorkshopEmployeeDetailsResponse {
  final WorkshopModel? workshop;
  final List<EmployeeElement>? employees;

  GetWorkshopEmployeeDetailsResponse({
    this.workshop,
    this.employees,
  });

  GetWorkshopEmployeeDetailsResponse copyWith({
    WorkshopModel? workshop,
    List<EmployeeElement>? employees,
  }) =>
      GetWorkshopEmployeeDetailsResponse(
        workshop: workshop ?? this.workshop,
        employees: employees ?? this.employees,
      );

  factory GetWorkshopEmployeeDetailsResponse.fromJson(Map<String, dynamic> json) => GetWorkshopEmployeeDetailsResponse(
    workshop: json["workshop"] == null ? null : WorkshopModel.fromJson(json["workshop"]),
    employees: json["employees"] == null ? [] : List<EmployeeElement>.from(json["employees"]!.map((x) => EmployeeElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "workshop": workshop?.toJson(),
    "employees": employees == null ? [] : List<dynamic>.from(employees!.map((x) => x.toJson())),
  };
}

class EmployeeElement {
  final EmployeeEmployee? employee;
  final double? totalRegularHours;
  final double? totalOvertimeHours;

  EmployeeElement({
    this.employee,
    this.totalRegularHours,
    this.totalOvertimeHours,
  });

  EmployeeElement copyWith({
    EmployeeEmployee? employee,
    double? totalRegularHours,
    double? totalOvertimeHours,
  }) =>
      EmployeeElement(
        employee: employee ?? this.employee,
        totalRegularHours: totalRegularHours ?? this.totalRegularHours,
        totalOvertimeHours: totalOvertimeHours ?? this.totalOvertimeHours,
      );

  factory EmployeeElement.fromJson(Map<String, dynamic> json) => EmployeeElement(
    employee: json["employee"] == null ? null : EmployeeEmployee.fromJson(json["employee"]),
    totalRegularHours: json["total_regular_hours"]?.toDouble(),
    totalOvertimeHours: json["total_overtime_hours"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "employee": employee?.toJson(),
    "total_regular_hours": totalRegularHours,
    "total_overtime_hours": totalOvertimeHours,
  };
}

class EmployeeEmployee {
  final int? id;
  final String? position;
  final String? department;
  final User? user;

  EmployeeEmployee({
    this.id,
    this.position,
    this.department,
    this.user,
  });

  EmployeeEmployee copyWith({
    int? id,
    String? position,
    String? department,
    User? user,
  }) =>
      EmployeeEmployee(
        id: id ?? this.id,
        position: position ?? this.position,
        department: department ?? this.department,
        user: user ?? this.user,
      );

  factory EmployeeEmployee.fromJson(Map<String, dynamic> json) => EmployeeEmployee(
    id: json["id"],
    position: json["position"],
    department: json["department"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "position": position,
    "department": department,
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? profileImageUrl;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.profileImageUrl,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? email,
    String? profileImageUrl,
  }) =>
      User(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        email: email ?? this.email,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    profileImageUrl: json["profile_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "email": email,
    "profile_image_url": profileImageUrl,
  };
}


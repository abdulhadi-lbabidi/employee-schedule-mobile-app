// class AttendanceModel {
//   final int id;
//   final AttendanceEmployee? employee;
//   final AttendanceWorkshop? workshop;
//   final int? employeeId;
//   final int? workshopId;
//   final DateTime? date;
//   final String? checkIn;
//   final String? checkOut;
//   final int? weekNumber;
//   final double? regularHours;
//   final double? overtimeHours;
//   final String? status;
//   final String? note;
//
//   AttendanceModel({
//     required this.id,
//     this.employee,
//     this.workshop,
//     this.employeeId,
//     this.workshopId,
//     this.date,
//     this.checkIn,
//     this.checkOut,
//     this.weekNumber,
//     this.regularHours,
//     this.overtimeHours,
//     this.status = 'synced',
//     this.note,
//   });
//
//   factory AttendanceModel.fromJson(Map<String, dynamic> json) {
//     return AttendanceModel(
//       id: json['id'] ?? 0,
//       employee:
//           json['employee'] != null
//               ? AttendanceEmployee.fromJson(json['employee'])
//               : null,
//       workshop:
//           json['workshop'] != null
//               ? AttendanceWorkshop.fromJson(json['workshop'])
//               : null,
//       employeeId: json['employeeId'],
//       workshopId: json['workshopId'],
//       date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
//       checkIn: json['check_in'],
//       checkOut: json['check_out'],
//       weekNumber: json['week_number'],
//       regularHours:
//           json['regular_hours'] != null
//               ? (json['regular_hours'] is double
//                   ? json['regular_hours']
//                   : double.tryParse(json['regular_hours'].toString()))
//               : null,
//       overtimeHours:
//           json['overtime_hours'] != null
//               ? (json['overtime_hours'] is double
//                   ? json['overtime_hours']
//                   : double.tryParse(json['overtime_hours'].toString()))
//               : null,
//       status: json['status'] ?? 'synced',
//       note: json['note'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "employee": employee?.toJson(),
//       "workshop": workshop?.toJson(),
//       "employeeId": employeeId,
//       "workshopId": workshopId,
//       "date": date?.toIso8601String(),
//       "check_in": checkIn,
//       "check_out": checkOut,
//       "week_number": weekNumber,
//       "regular_hours": regularHours,
//       "overtime_hours": overtimeHours,
//       "status": status,
//       "note": note,
//     };
//   }
//
//   AttendanceModel copyWith({
//     int? id,
//     AttendanceEmployee? employee,
//     AttendanceWorkshop? workshop,
//     int? employeeId,
//     int? workshopId,
//     DateTime? date,
//     String? checkIn,
//     String? checkOut,
//     int? weekNumber,
//     double? regularHours,
//     double? overtimeHours,
//     String? status,
//     String? note,
//   }) {
//     return AttendanceModel(
//       id: id ?? this.id,
//       employee: employee ?? this.employee,
//       workshop: workshop ?? this.workshop,
//       employeeId: employeeId ?? this.employeeId,
//       workshopId: workshopId ?? this.workshopId,
//       date: date ?? this.date,
//       checkIn: checkIn ?? this.checkIn,
//       checkOut: checkOut ?? this.checkOut,
//       weekNumber: weekNumber ?? this.weekNumber,
//       regularHours: regularHours ?? this.regularHours,
//       overtimeHours: overtimeHours ?? this.overtimeHours,
//       status: status ?? this.status,
//       note: note ?? this.note,
//     );
//   }
// }
//
// class AttendanceEmployee {
//   final int id;
//   final String? position;
//   final String? department;
//   final AttendanceUser? user;
//
//   AttendanceEmployee({
//     required this.id,
//     this.position,
//     this.department,
//     this.user,
//   });
//
//   factory AttendanceEmployee.fromJson(Map<String, dynamic> json) {
//     return AttendanceEmployee(
//       id: json['id'] ?? 0,
//       position: json['position'],
//       department: json['department'],
//       user: json['user'] != null ? AttendanceUser.fromJson(json['user']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "position": position,
//       "department": department,
//       "user": user?.toJson(),
//     };
//   }
// }
//
// class AttendanceUser {
//   final int id;
//   final String? fullName;
//   final String? phoneNumber;
//   final String? email;
//   final String? profileImageUrl;
//
//   AttendanceUser({
//     required this.id,
//     this.fullName,
//     this.phoneNumber,
//     this.email,
//     this.profileImageUrl,
//   });
//
//   factory AttendanceUser.fromJson(Map<String, dynamic> json) {
//     return AttendanceUser(
//       id: json['id'] ?? 0,
//       fullName: json['full_name'],
//       phoneNumber: json['phone_number'],
//       email: json['email'],
//       profileImageUrl: json['profile_image_url'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "full_name": fullName,
//       "phone_number": phoneNumber,
//       "email": email,
//       "profile_image_url": profileImageUrl,
//     };
//   }
// }
//
// class AttendanceWorkshop {
//   final int id;
//   final String? name;
//   final String? location;
//
//   AttendanceWorkshop({required this.id, this.name, this.location});
//
//   factory AttendanceWorkshop.fromJson(Map<String, dynamic> json) {
//     return AttendanceWorkshop(
//       id: json['id'] ?? 0,
//       name: json['name'],
//       location: json['location'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {"id": id, "name": name, "location": location};
//   }
// }

class AttendanceModel {
  final int? id;
  final Employee? employee;
  final Workshop? workshop;
  final DateTime? date;
  final String? checkIn;
  final String? checkOut;
  final int? weekNumber;
  final double? regularHours;
  final double? overtimeHours;
  final String? status;
  final dynamic note;

  AttendanceModel({
    this.id,
    this.employee,
    this.workshop,
    this.date,
    this.checkIn,
    this.checkOut,
    this.weekNumber,
    this.regularHours,
    this.overtimeHours,
    this.status,
    this.note,
  });

  AttendanceModel copyWith({
    int? id,
    Employee? employee,
    Workshop? workshop,
    DateTime? date,
    String? checkIn,
    String? checkOut,
    int? weekNumber,
    double? regularHours,
    double? overtimeHours,
    String? status,
    dynamic note,
  }) =>
      AttendanceModel(
        id: id ?? this.id,
        employee: employee ?? this.employee,
        workshop: workshop ?? this.workshop,
        date: date ?? this.date,
        checkIn: checkIn ?? this.checkIn,
        checkOut: checkOut ?? this.checkOut,
        weekNumber: weekNumber ?? this.weekNumber,
        regularHours: regularHours ?? this.regularHours,
        overtimeHours: overtimeHours ?? this.overtimeHours,
        status: status ?? this.status,
        note: note ?? this.note,
      );

  factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
    id: json["id"],
    employee: json["employee"] == null ? null : Employee.fromJson(json["employee"]),
    workshop: json["workshop"] == null ? null : Workshop.fromJson(json["workshop"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    checkIn: json["check_in"],
    checkOut: json["check_out"],
    weekNumber: json["week_number"],
    regularHours: json["regular_hours"] != null
        ? (json["regular_hours"] is int
        ? (json["regular_hours"] as int).toDouble()
        : json["regular_hours"] as double)
        : null,
    overtimeHours: json["overtime_hours"] != null
        ? (json["overtime_hours"] is int
        ? (json["overtime_hours"] as int).toDouble()
        : json["overtime_hours"] as double)
        : null,
    status: json["status"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee": employee?.toJson(),
    "workshop": workshop?.toJson(),
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "check_in": checkIn,
    "check_out": checkOut,
    "week_number": weekNumber,
    "regular_hours": regularHours,
    "overtime_hours": overtimeHours,
    "status": status,
    "note": note,
  };
}


class Employee {
  final int? id;
  final String? position;
  final String? department;
  final User? user;

  Employee({
    this.id,
    this.position,
    this.department,
    this.user,
  });

  Employee copyWith({
    int? id,
    String? position,
    String? department,
    User? user,
  }) =>
      Employee(
        id: id ?? this.id,
        position: position ?? this.position,
        department: department ?? this.department,
        user: user ?? this.user,
      );

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
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

class Workshop {
  final int? id;
  final String? name;
  final String? location;

  Workshop({
    this.id,
    this.name,
    this.location,
  });

  Workshop copyWith({
    int? id,
    String? name,
    String? location,
  }) =>
      Workshop(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
      );

  factory Workshop.fromJson(Map<String, dynamic> json) => Workshop(
    id: json["id"],
    name: json["name"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
  };
}
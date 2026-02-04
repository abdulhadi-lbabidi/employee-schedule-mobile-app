class AttendanceModel {
  final int id;
  final AttendanceEmployee? employee;
  final AttendanceWorkshop? workshop;
  final int? employeeId;
  final int? workshopId;
  final DateTime? date;
  final String? checkIn;
  final String? checkOut;
  final int? weekNumber;
  final double? regularHours;
  final double? overtimeHours;
  final String? status;
  final String? note;

  AttendanceModel({
    required this.id,
    this.employee,
    this.workshop,
    this.employeeId,
    this.workshopId,
    this.date,
    this.checkIn,
    this.checkOut,
    this.weekNumber,
    this.regularHours,
    this.overtimeHours,
    this.status = 'synced',
    this.note,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? 0,
      employee:
          json['employee'] != null
              ? AttendanceEmployee.fromJson(json['employee'])
              : null,
      workshop:
          json['workshop'] != null
              ? AttendanceWorkshop.fromJson(json['workshop'])
              : null,
      employeeId: json['employeeId'],
      workshopId: json['workshopId'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      weekNumber: json['week_number'],
      regularHours:
          json['regular_hours'] != null
              ? (json['regular_hours'] is double
                  ? json['regular_hours']
                  : double.tryParse(json['regular_hours'].toString()))
              : null,
      overtimeHours:
          json['overtime_hours'] != null
              ? (json['overtime_hours'] is double
                  ? json['overtime_hours']
                  : double.tryParse(json['overtime_hours'].toString()))
              : null,
      status: json['status'] ?? 'synced',
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "employee": employee?.toJson(),
      "workshop": workshop?.toJson(),
      "employeeId": employeeId,
      "workshopId": workshopId,
      "date": date?.toIso8601String(),
      "check_in": checkIn,
      "check_out": checkOut,
      "week_number": weekNumber,
      "regular_hours": regularHours,
      "overtime_hours": overtimeHours,
      "status": status,
      "note": note,
    };
  }

  AttendanceModel copyWith({
    int? id,
    AttendanceEmployee? employee,
    AttendanceWorkshop? workshop,
    int? employeeId,
    int? workshopId,
    DateTime? date,
    String? checkIn,
    String? checkOut,
    int? weekNumber,
    double? regularHours,
    double? overtimeHours,
    String? status,
    String? note,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      employee: employee ?? this.employee,
      workshop: workshop ?? this.workshop,
      employeeId: employeeId ?? this.employeeId,
      workshopId: workshopId ?? this.workshopId,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      weekNumber: weekNumber ?? this.weekNumber,
      regularHours: regularHours ?? this.regularHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      status: status ?? this.status,
      note: note ?? this.note,
    );
  }
}

class AttendanceEmployee {
  final int id;
  final String? position;
  final String? department;
  final AttendanceUser? user;

  AttendanceEmployee({
    required this.id,
    this.position,
    this.department,
    this.user,
  });

  factory AttendanceEmployee.fromJson(Map<String, dynamic> json) {
    return AttendanceEmployee(
      id: json['id'] ?? 0,
      position: json['position'],
      department: json['department'],
      user: json['user'] != null ? AttendanceUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "position": position,
      "department": department,
      "user": user?.toJson(),
    };
  }
}

class AttendanceUser {
  final int id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final String? profileImageUrl;

  AttendanceUser({
    required this.id,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.profileImageUrl,
  });

  factory AttendanceUser.fromJson(Map<String, dynamic> json) {
    return AttendanceUser(
      id: json['id'] ?? 0,
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "full_name": fullName,
      "phone_number": phoneNumber,
      "email": email,
      "profile_image_url": profileImageUrl,
    };
  }
}

class AttendanceWorkshop {
  final int id;
  final String? name;
  final String? location;

  AttendanceWorkshop({required this.id, this.name, this.location});

  factory AttendanceWorkshop.fromJson(Map<String, dynamic> json) {
    return AttendanceWorkshop(
      id: json['id'] ?? 0,
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "location": location};
  }
}

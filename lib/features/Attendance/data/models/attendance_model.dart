class AttendanceModel {
  final int id;
  final AttendanceEmployee employee;
  final AttendanceWorkshop workshop;
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final int weekNumber;
  final double regularHours;
  final double overtimeHours;
  final String? status;
  final String? note;

  AttendanceModel({
    required this.id,
    required this.employee,
    required this.workshop,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.weekNumber,
    required this.regularHours,
    required this.overtimeHours,
    this.status,
    this.note,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      employee: AttendanceEmployee.fromJson(json['employee']),
      workshop: AttendanceWorkshop.fromJson(json['workshop']),
      date: DateTime.parse(json['date']),
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      weekNumber: int.parse(json['week_number'].toString()),
      regularHours: double.parse(json['regular_hours'].toString()),
      overtimeHours: double.parse(json['overtime_hours'].toString()),
      status: json['status'],
      note: json['note'],
    );
  }
}
class AttendanceEmployee {
  final int id;
  final String position;
  final String department;
  final AttendanceUser user;

  AttendanceEmployee({
    required this.id,
    required this.position,
    required this.department,
    required this.user,
  });

  factory AttendanceEmployee.fromJson(Map<String, dynamic> json) {
    return AttendanceEmployee(
      id: json['id'],
      position: json['position']??'',
      department: json['department']??'',
      user: AttendanceUser.fromJson(json['user']),
    );
  }
}
class AttendanceUser {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String? email;
  final String? profileImageUrl;

  AttendanceUser({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.email,
    this.profileImageUrl,
  });

  factory AttendanceUser.fromJson(Map<String, dynamic> json) {
    return AttendanceUser(
      id: json['id'],
      fullName: json['full_name']??'',
      phoneNumber: json['phone_number']??'',
      email: json['email']??'',
      profileImageUrl: json['profile_image_url']??'',
    );
  }
}
class AttendanceWorkshop {
  final int id;
  final String name;
  final String location;

  AttendanceWorkshop({
    required this.id,
    required this.name,
    required this.location,
  });

  factory AttendanceWorkshop.fromJson(Map<String, dynamic> json) {
    return AttendanceWorkshop(
      id: json['id'],
      name: json['name']??'',
      location: json['location']??'',
    );
  }
}

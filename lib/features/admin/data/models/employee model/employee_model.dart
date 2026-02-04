import '../../../domain/entities/employee_entity.dart';
import 'dart:convert';

import '../workshop_model.dart';

class Datum {
  final int id;
  final String position;
  final String department;
  final double hourlyRate;
  final double overtimeRate;
  final bool isOnline;
  final String currentLocation;
  final UserModel user;
  final List<WorkshopModel> workshops;

  Datum({
    required this.id,
    required this.position,
    required this.department,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.isOnline,
    required this.currentLocation,
    required this.user,
    required this.workshops,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['id'],
      position: json['position'] ?? 'Unknown',
      department: json['department'] ?? 'Unknown',

      hourlyRate: json['hourly_rate']?.toDouble() ?? 0.0,
      overtimeRate: json['overtime_rate']?.toDouble() ?? 0.0,
      isOnline: json['is_online'],
      currentLocation: json['current_location'],
      user: UserModel.fromJson(json['user']),
      workshops: (json['workshops'] as List? ?? [])
          .map((e) => WorkshopModel.fromJson(e))
          .toList(),
    );
  }
}

class UserModel {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? '',
    );
  }
}

//
// class User {
//   final int? id;
//   final String? fullName;
//   final String? phoneNumber;
//   final String? email;
//
//   User({
//     this.id,
//     this.fullName,
//     this.phoneNumber,
//     this.email,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) =>
//       User(
//         id: json["id"],
//         fullName: json["full_name"] ?? '',
//         phoneNumber: json["phone_number"] ?? '',
//         email: json["email"] ?? '',
//       );
//
//   Map<String, dynamic> toJson() =>
//       {
//         'id': id,
//         'fullName': fullName,
//         'phoneNumber': phoneNumber,
//         'email': email,
//
//
//       };
// }
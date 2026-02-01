import '../../domain/entities/admin_profile_entity.dart';

class AdminProfileModel extends AdminProfileEntity {
  const AdminProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phoneNumber,
    required super.position,
    required super.department,
    super.profileImageUrl,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? json['phoneNumber'] ?? '',
      position: json['position'] ?? '',
      department: json['department'] ?? '',
      profileImageUrl: json['profile_image_url'] ?? json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'position': position,
      'department': department,
      'profile_image_url': profileImageUrl,
    };
  }
}

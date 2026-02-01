// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  final String? token;
  final User? user;
  final int? status;
  final String? role;

  LoginResponse({
    this.token,
    this.user,
    this.status,
    this.role,
  });

  LoginResponse copyWith({
    String? token,
    User? user,
    int? status,
    String? role,
  }) =>
      LoginResponse(
        token: token ?? this.token,
        user: user ?? this.user,
        status: status ?? this.status,
        role: role ?? this.role,
      );

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    status: json["status"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
    "status": status,
    "role": role,
  };
}

class User {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final dynamic profileImageUrl;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? isArchived;
  final String? userableType;
  final int? userableId;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Userable? userable;

  User({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.profileImageUrl,
    this.email,
    this.emailVerifiedAt,
    this.isArchived,
    this.userableType,
    this.userableId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userable,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    dynamic profileImageUrl,
    String? email,
    dynamic emailVerifiedAt,
    String? isArchived,
    String? userableType,
    int? userableId,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Userable? userable,
  }) =>
      User(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        isArchived: isArchived ?? this.isArchived,
        userableType: userableType ?? this.userableType,
        userableId: userableId ?? this.userableId,
        deletedAt: deletedAt ?? this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        userable: userable ?? this.userable,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fullName: json["full_name"],
    phoneNumber: json["phone_number"],
    profileImageUrl: json["profile_image_url"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    isArchived: json["is_archived"],
    userableType: json["userable_type"],
    userableId: json["userable_id"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    userable: json["userable"] == null ? null : Userable.fromJson(json["userable"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "phone_number": phoneNumber,
    "profile_image_url": profileImageUrl,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "is_archived": isArchived,
    "userable_type": userableType,
    "userable_id": userableId,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "userable": userable?.toJson(),
  };
}

class Userable {
  final int? id;
  final String? name;
  final num? hourlyRate; // 🔹 إضافة
  final num? overtimeRate; // 🔹 إضافة
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Userable({
    this.id,
    this.name,
    this.hourlyRate,
    this.overtimeRate,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Userable copyWith({
    int? id,
    String? name,
    num? hourlyRate,
    num? overtimeRate,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Userable(
        id: id ?? this.id,
        name: name ?? this.name,
        hourlyRate: hourlyRate ?? this.hourlyRate,
        overtimeRate: overtimeRate ?? this.overtimeRate,
        deletedAt: deletedAt ?? this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Userable.fromJson(Map<String, dynamic> json) => Userable(
    id: json["id"],
    name: json["name"],
    hourlyRate: json["hourly_rate"],
    overtimeRate: json["overtime_rate"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hourly_rate": hourlyRate,
    "overtime_rate": overtimeRate,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

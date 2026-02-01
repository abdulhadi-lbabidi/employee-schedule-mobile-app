class ProfileModel {
  final User? user;
  final String? role;
  final int? status;

  ProfileModel({
    this.user,
    this.role,
    this.status,
  });

  ProfileModel copyWith({
    User? user,
    String? role,
    int? status,
  }) =>
      ProfileModel(
        user: user ?? this.user,
        role: role ?? this.role,
        status: status ?? this.status,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        role: json["role"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "role": role,
        "status": status,
      };
}

class User {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? isArchived;
  final String? userableType;
  final int? userableId;
  final dynamic fcmToken;
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
    this.fcmToken,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.userable,
  });

  User copyWith({
    int? id,
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
    String? email,
    dynamic emailVerifiedAt,
    String? isArchived,
    String? userableType,
    int? userableId,
    dynamic fcmToken,
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
        fcmToken: fcmToken ?? this.fcmToken,
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
        isArchived: json["is_archived"]?.toString(),
        userableType: json["userable_type"],
        userableId: json["userable_id"],
        fcmToken: json["fcm_token"],
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
        "fcm_token": fcmToken,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "userable": userable?.toJson(),
      };
}

class Userable {
  final int? id;
  final String? position;
  final String? department;
  final double? hourlyRate;
  final double? overtimeRate;
  final bool? isOnline;
  final String? currentLocation;
  final dynamic deletedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Userable({
    this.id,
    this.position,
    this.department,
    this.hourlyRate,
    this.overtimeRate,
    this.isOnline,
    this.currentLocation,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Userable copyWith({
    int? id,
    String? position,
    String? department,
    double? hourlyRate,
    double? overtimeRate,
    bool? isOnline,
    String? currentLocation,
    dynamic deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Userable(
        id: id ?? this.id,
        position: position ?? this.position,
        department: department ?? this.department,
        hourlyRate: hourlyRate ?? this.hourlyRate,
        overtimeRate: overtimeRate ?? this.overtimeRate,
        isOnline: isOnline ?? this.isOnline,
        currentLocation: currentLocation ?? this.currentLocation,
        deletedAt: deletedAt ?? this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Userable.fromJson(Map<String, dynamic> json) => Userable(
        id: json["id"],
        position: json["position"],
        department: json["department"],
        hourlyRate: json["hourly_rate"] != null ? (json["hourly_rate"] as num).toDouble() : null,
        overtimeRate: json["overtime_rate"] != null ? (json["overtime_rate"] as num).toDouble() : null,
        isOnline: json["is_online"] is bool ? json["is_online"] : (json["is_online"] == 1),
        currentLocation: json["current_location"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "position": position,
        "department": department,
        "hourly_rate": hourlyRate,
        "overtime_rate": overtimeRate,
        "is_online": isOnline,
        "current_location": currentLocation,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}




GetAllEmployeeResponse getAllEmployeeResponseFromJson( str) => GetAllEmployeeResponse.fromJson(str);


class GetAllEmployeeResponse {
  final List<EmployeeModel>? data;

  GetAllEmployeeResponse({
    this.data,
  });

  factory GetAllEmployeeResponse.fromJson(Map<String, dynamic> json) => GetAllEmployeeResponse(
    data: json["data"] == null ? [] : List<EmployeeModel>.from(json["data"]!.map((x) => EmployeeModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };

  GetAllEmployeeResponse copyWith({
    List<EmployeeModel>? data,
  }) {
    return GetAllEmployeeResponse(
      data: data ?? this.data,
    );
  }
}
class EmployeeModel {
  final int? id;
  final String? position;
  final String? department;
  final double? hourlyRate;
  final double? overtimeRate;
  final bool? isOnline;
  final String? currentLocation;
  final User? user;
  final List<Workshop>? workshops;

  EmployeeModel({
    this.id,
    this.position,
    this.department,
    this.hourlyRate,
    this.overtimeRate,
    this.isOnline=false,
    this.currentLocation,
    this.user,
    this.workshops,
  });

  EmployeeModel copyWith({
    int? id,
    String? position,
    String? department,
    double? hourlyRate,
    double? overtimeRate,
    bool? isOnline,
    String? currentLocation,
    User? user,
    List<Workshop>? workshops,
  }) =>
      EmployeeModel(
        id: id ?? this.id,
        position: position ?? this.position,
        department: department ?? this.department,
        hourlyRate: hourlyRate ?? this.hourlyRate,
        overtimeRate: overtimeRate ?? this.overtimeRate,
        isOnline: isOnline ?? this.isOnline,
        currentLocation: currentLocation ?? this.currentLocation,
        user: user ?? this.user,
        workshops: workshops ?? this.workshops,
      );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
    id: json["id"],
    position: json["position"],
    department: json["department"],
    hourlyRate: json["hourly_rate"] == null
        ? null
        : (json["hourly_rate"] as num).toDouble(),
    overtimeRate: json["overtime_rate"] == null
        ? null
        : (json["overtime_rate"] as num).toDouble(),
    isOnline: json["is_online"],
    currentLocation: json["current_location"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    workshops: json["workshops"] == null
        ? []
        : List<Workshop>.from(
        json["workshops"]!.map((x) => Workshop.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "position": position,
    "department": department,
    "hourly_rate": hourlyRate,
    "overtime_rate": overtimeRate,
    "is_online": isOnline,
    "current_location": currentLocation,
    "user": user?.toJson(),
    "workshops": workshops == null
        ? []
        : List<dynamic>.from(workshops!.map((x) => x.toJson())),
  };
}

class User {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final dynamic profileImageUrl;

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
    dynamic profileImageUrl,
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

class WorkshopEntity {
  final int? id;
  final String? name;
  final double? latitude;
  final double? longitude;
  final double radiusInMeters;
  final int employeeCount;
  final bool isArchived; // 🔹 حقل الأرشفة

  const WorkshopEntity({
    required this.id,
     this.name,
    this.latitude,
    this.longitude,
    this.radiusInMeters = 200,
    this.employeeCount = 0,
    this.isArchived = false,
  });

  bool get hasLocation => latitude != null && longitude != null;

  /// 🔹 تحويل من JSON إلى كائن
  factory WorkshopEntity.fromJson(Map<String, dynamic> json) {
    return WorkshopEntity(
      id: json['id'] ,
      name: json['name'] as String?,
      latitude: (json['latitude'] != null) ? (json['latitude'] as num).toDouble() : null,
      longitude: (json['longitude'] != null) ? (json['longitude'] as num).toDouble() : null,
      radiusInMeters: (json['radiusInMeters'] != null)
          ? (json['radiusInMeters'] as num).toDouble()
          : 200,
      employeeCount: json['employeeCount'] != null ? json['employeeCount'] as int : 0,
      isArchived: json['isArchived'] != null ? json['isArchived'] as bool : false,
    );
  }

  /// 🔹 تحويل الكائن إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radiusInMeters': radiusInMeters,
      'employeeCount': employeeCount,
      'isArchived': isArchived,
    };
  }
}

class WorkshopModel {
  final int? id;
  final String? name;
  final String? location;
  final String? description;
  final double? latitude;
  final double? longitude;
  final double? radiusInMeters;
  final DateTime? createdAt;

  WorkshopModel({
    this.id,
    this.name,
    this.location,
    this.description,
    this.latitude,
    this.longitude,
    this.radiusInMeters,
    this.createdAt,
  });

  WorkshopModel copyWith({
    int? id,
    String? name,
    String? location,
    String? description,
    double? latitude,
    double? longitude,
    double? radiusInMeters,
    DateTime? createdAt,
  }) => WorkshopModel(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location ?? this.location,
    description: description ?? this.description,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radiusInMeters: radiusInMeters ?? this.radiusInMeters,
    createdAt: createdAt ?? this.createdAt,
  );

  factory WorkshopModel.fromJson(Map<String, dynamic> json) => WorkshopModel(
    id: json["id"],
    name: json["name"],
    location: json["location"],
    description: json["description"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    radiusInMeters: json["radiusInMeters"]?.toDouble(),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location": location,
    "description": description,
    "latitude": latitude,
    "longitude": longitude,
    "radiusInMeters": radiusInMeters,
    "created_at": createdAt?.toIso8601String(),
  };
}

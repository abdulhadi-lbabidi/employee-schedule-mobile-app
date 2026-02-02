class WorkshopEntity {
  final String id;
  final String name;
  final String location; // 🔹 حقل الموقع
  final String description; // 🔹 حقل الوصف
  final double? latitude;
  final double? longitude;
  final double radiusInMeters;
  final int employeeCount;
  final bool isArchived; // 🔹 حقل الأرشفة

  const WorkshopEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    this.latitude,
    this.longitude,
    this.radiusInMeters = 200,
    this.employeeCount = 0,
    this.isArchived = false,
  });

  bool get hasLocation => latitude != null && longitude != null;
}

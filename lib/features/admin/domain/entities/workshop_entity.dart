class WorkshopEntity {
  final String id;
  final String name;
  final double? latitude;
  final double? longitude;
  final double radiusInMeters;
  final int employeeCount;
  final bool isArchived; // 🔹 حقل الأرشفة

  const WorkshopEntity({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    this.radiusInMeters = 200,
    this.employeeCount = 0,
    this.isArchived = false,
  });

  bool get hasLocation => latitude != null && longitude != null;
}

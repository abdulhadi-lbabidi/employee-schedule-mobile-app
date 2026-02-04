import '../../../admin/data/models/workshop_model.dart';
import '../../../admin/domain/entities/workshop_entity.dart';
extension WorkshopeToEntityMapper on WorkshopModel {
  WorkshopEntity toEntity() {
    return WorkshopEntity(
      id: this.id,
      name: this.name.toString(), // استخدم name مباشرة
      // بما أن Workshope لا يحتوي على latitude/longitude/radius مباشرة، قم بتعيين قيم افتراضية أو null
      latitude: null,
      longitude: null,
      radiusInMeters: 200.0, // قيمة افتراضية
      employeeCount: 0, // قيمة افتراضية
      isArchived: false, // قيمة افتراضية
    );
  }
}

import '../../domain/entities/workshop_entity.dart';
import '../models/workshop_model.dart';

class WorkshopMapper {
  static WorkshopEntity toEntity(WorkshopModel model) {
    return WorkshopEntity(
      id: model.id?.toString() ?? '0',
      name: model.name ?? 'Unknown',
      latitude: model.latitude?.toDouble(),
      longitude: model.longitude?.toDouble(),
      radiusInMeters: model.radius?.toDouble() ?? 200.0,
      employeeCount: model.employeeCount ?? 0,
      isArchived: model.isArchived ?? false,
    );
  }

  static List<WorkshopEntity> toEntityList(List<dynamic> list) {
    return list
        .map((json) => toEntity(WorkshopModel.fromJson(json as Map<String, dynamic>)))
        .toList();
  }
}

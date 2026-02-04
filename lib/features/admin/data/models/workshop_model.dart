// file: lib/features/admin/data/models/workshop_model.dart

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/workshop_entity.dart';

part 'workshop_model.g.dart';

@HiveType(typeId: 20) // تم تغيير المعرف ليكون فريداً ومنع التداخل
class WorkshopModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? location;
  @HiveField(3)
  final num? latitude;
  @HiveField(4)
  final num? longitude;
  @HiveField(5)
  final num? radius;
  @HiveField(6)
  final int? employeeCount;
  @HiveField(7)
  final bool? isArchived;
  
  WorkshopModel({
    this.id,
    this.name,
    this.location,
    this.latitude,
    this.longitude,
    this.radius,
    this.employeeCount,
    this.isArchived,
  });

  factory WorkshopModel.fromJson(Map<String, dynamic> json) {
    return WorkshopModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      location: json['location'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
      radius: json['radius'] as num?,
      employeeCount: json['employee_count'] as int?, 
      isArchived: _safeToBool(json['is_archived']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'employee_count': employeeCount,
      'is_archived': isArchived,
    };
  }

  static WorkshopEntity toEntity(WorkshopModel model) {
    return WorkshopEntity(
      id: model.id ?? 0,
      name: model.name ?? model.location ?? 'Unknown',
      latitude: model.latitude?.toDouble(),
      longitude: model.longitude?.toDouble(),
      radiusInMeters: model.radius?.toDouble() ?? 200.0,
      employeeCount: model.employeeCount ?? 0,
      isArchived: model.isArchived ?? false,
    );
  }

  static WorkshopModel fromEntity(WorkshopEntity entity) {
    return WorkshopModel(
      id: entity.id,
      name: entity.name,
      location: entity.name,
      latitude: entity.latitude,
      longitude: entity.longitude,
      radius: entity.radiusInMeters,
      isArchived: entity.isArchived,
    );
  }

  static bool? _safeToBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return null;
  }
}

extension WorkshopModelExtension on WorkshopModel {
  WorkshopEntity toEntity() => WorkshopModel.toEntity(this);
}

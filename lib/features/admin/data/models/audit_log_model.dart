import 'package:hive/hive.dart';

@HiveType(typeId: 15)
class AuditLogModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String adminName;
  @HiveField(2)
  final String actionType;
  @HiveField(3)
  final String targetName;
  @HiveField(4)
  final String details;
  @HiveField(5)
  final DateTime timestamp;

  AuditLogModel({
    required this.id,
    required this.adminName,
    required this.actionType,
    required this.targetName,
    required this.details,
    required this.timestamp,
  });
}

class AuditLogModelAdapter extends TypeAdapter<AuditLogModel> {
  @override
  final int typeId = 15;

  @override
  AuditLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuditLogModel(
      id: fields[0] as String,
      adminName: fields[1] as String,
      actionType: fields[2] as String,
      targetName: fields[3] as String,
      details: fields[4] as String,
      timestamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AuditLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.adminName)
      ..writeByte(2)
      ..write(obj.actionType)
      ..writeByte(3)
      ..write(obj.targetName)
      ..writeByte(4)
      ..write(obj.details)
      ..writeByte(5)
      ..write(obj.timestamp);
  }
}

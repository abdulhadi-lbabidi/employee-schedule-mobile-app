// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workshop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkshopModelAdapter extends TypeAdapter<WorkshopModel> {
  @override
  final int typeId = 20;

  @override
  WorkshopModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkshopModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      location: fields[2] as String?,
      latitude: fields[3] as num?,
      longitude: fields[4] as num?,
      radius: fields[5] as num?,
      employeeCount: fields[6] as int?,
      isArchived: fields[7] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkshopModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.radius)
      ..writeByte(6)
      ..write(obj.employeeCount)
      ..writeByte(7)
      ..write(obj.isArchived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkshopModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

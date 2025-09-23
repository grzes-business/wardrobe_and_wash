// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wash_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WashPlanAdapter extends TypeAdapter<WashPlan> {
  @override
  final int typeId = 2;

  @override
  WashPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WashPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      clothingIds: (fields[2] as List).cast<String>(),
      createdAt: fields[3] as DateTime,
      isCompleted: fields[4] as bool,
      completedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WashPlan obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.clothingIds)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WashPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

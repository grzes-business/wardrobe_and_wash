// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingAdapter extends TypeAdapter<Clothing> {
  @override
  final int typeId = 1;

  @override
  Clothing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Clothing(
      id: fields[0] as String,
      name: fields[1] as String,
      assetPath: fields[2] as String?,
      category: fields[3] as ClothingCategory,
      wornCount: fields[4] as int,
      previousWornCount: fields[5] as int,
      isInTodaySet: fields[6] as bool,
      createdAt: fields[7] as DateTime,
      lastWornAt: fields[8] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Clothing obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.assetPath)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.wornCount)
      ..writeByte(5)
      ..write(obj.previousWornCount)
      ..writeByte(6)
      ..write(obj.isInTodaySet)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.lastWornAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

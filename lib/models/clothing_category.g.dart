// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clothing_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClothingCategoryAdapter extends TypeAdapter<ClothingCategory> {
  @override
  final int typeId = 0;

  @override
  ClothingCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ClothingCategory.underwear;
      case 1:
        return ClothingCategory.tshirt;
      case 2:
        return ClothingCategory.shirt;
      case 3:
        return ClothingCategory.pants;
      case 4:
        return ClothingCategory.dress;
      case 5:
        return ClothingCategory.jacket;
      case 6:
        return ClothingCategory.shoes;
      case 7:
        return ClothingCategory.socks;
      case 8:
        return ClothingCategory.others;
      default:
        return ClothingCategory.underwear;
    }
  }

  @override
  void write(BinaryWriter writer, ClothingCategory obj) {
    switch (obj) {
      case ClothingCategory.underwear:
        writer.writeByte(0);
        break;
      case ClothingCategory.tshirt:
        writer.writeByte(1);
        break;
      case ClothingCategory.shirt:
        writer.writeByte(2);
        break;
      case ClothingCategory.pants:
        writer.writeByte(3);
        break;
      case ClothingCategory.dress:
        writer.writeByte(4);
        break;
      case ClothingCategory.jacket:
        writer.writeByte(5);
        break;
      case ClothingCategory.shoes:
        writer.writeByte(6);
        break;
      case ClothingCategory.socks:
        writer.writeByte(7);
        break;
      case ClothingCategory.others:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClothingCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

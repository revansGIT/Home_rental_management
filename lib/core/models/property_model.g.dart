// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyModelAdapter extends TypeAdapter<PropertyModel> {
  @override
  final int typeId = 0;

  @override
  PropertyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyModel(
      id: fields[0] as String,
      name: fields[1] as String,
      address: fields[2] as String,
      totalUnits: fields[3] as int,
      yearBuilt: fields[4] as int,
      imagePath: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.totalUnits)
      ..writeByte(4)
      ..write(obj.yearBuilt)
      ..writeByte(5)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

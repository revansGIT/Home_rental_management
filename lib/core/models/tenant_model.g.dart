// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TenantModelAdapter extends TypeAdapter<TenantModel> {
  @override
  final int typeId = 2;

  @override
  TenantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TenantModel(
      id: fields[0] as String,
      name: fields[1] as String,
      phone: fields[2] as String,
      unitId: fields[3] as String,
      leaseStart: fields[4] as DateTime,
      leaseEnd: fields[5] as DateTime,
      advancePaid: fields[6] as double,
      serviceCharge: fields[7] as double,
      imagePath: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TenantModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.unitId)
      ..writeByte(4)
      ..write(obj.leaseStart)
      ..writeByte(5)
      ..write(obj.leaseEnd)
      ..writeByte(6)
      ..write(obj.advancePaid)
      ..writeByte(7)
      ..write(obj.serviceCharge)
      ..writeByte(8)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TenantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

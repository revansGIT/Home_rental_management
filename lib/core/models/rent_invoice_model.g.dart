// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RentInvoiceModelAdapter extends TypeAdapter<RentInvoiceModel> {
  @override
  final int typeId = 5;

  @override
  RentInvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RentInvoiceModel(
      id: fields[0] as String,
      tenantId: fields[1] as String,
      unitId: fields[2] as String,
      monthYear: fields[3] as DateTime,
      dueDate: fields[4] as DateTime,
      baseRent: fields[5] as double,
      serviceCharge: fields[6] as double,
      otherCharges: fields[7] as double,
      previousBalance: fields[8] as double,
      amountPaid: fields[9] as double,
      status: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RentInvoiceModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tenantId)
      ..writeByte(2)
      ..write(obj.unitId)
      ..writeByte(3)
      ..write(obj.monthYear)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.baseRent)
      ..writeByte(6)
      ..write(obj.serviceCharge)
      ..writeByte(7)
      ..write(obj.otherCharges)
      ..writeByte(8)
      ..write(obj.previousBalance)
      ..writeByte(9)
      ..write(obj.amountPaid)
      ..writeByte(10)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RentInvoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillModelAdapter extends TypeAdapter<BillModel> {
  @override
  final int typeId = 27;

  @override
  BillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillModel(
      id: fields[0] as String,
      billNumber: fields[1] as String,
      warehouseId: fields[3] as String,
      cashierId: fields[4] as String,
      customer: fields[5] as CustomerModel?,
      items: (fields[6] as List).cast<BillItemModel>(),
      subTotal: fields[7] as double,
      discount: fields[8] as double,
      tax: fields[9] as double,
      grandTotal: fields[10] as double,
      payment: fields[11] as PaymentSummaryModel,
      status: fields[12] as BillStatus,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
      synced: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BillModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.billNumber)
      ..writeByte(3)
      ..write(obj.warehouseId)
      ..writeByte(4)
      ..write(obj.cashierId)
      ..writeByte(5)
      ..write(obj.customer)
      ..writeByte(6)
      ..write(obj.items)
      ..writeByte(7)
      ..write(obj.subTotal)
      ..writeByte(8)
      ..write(obj.discount)
      ..writeByte(9)
      ..write(obj.tax)
      ..writeByte(10)
      ..write(obj.grandTotal)
      ..writeByte(11)
      ..write(obj.payment)
      ..writeByte(12)
      ..write(obj.status)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

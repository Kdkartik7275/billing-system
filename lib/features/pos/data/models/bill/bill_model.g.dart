// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillModelAdapter extends TypeAdapter<BillModel> {
  @override
  final int typeId = 2;

  @override
  BillModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillModel(
      id: fields[0] as String,
      receiptNumber: fields[1] as String,
      createdAt: fields[2] as DateTime,
      customerName: fields[3] as String?,
      customerPhone: fields[4] as String?,
      items: (fields[5] as List).cast<BillItemModel>(),
      subtotal: fields[6] as double,
      taxRate: fields[7] as double,
      taxAmount: fields[8] as double,
      grandTotal: fields[9] as double,
      paymentMethod: fields[10] as String,
      amountTendered: fields[11] as double,
      changeGiven: fields[12] as double,
      status: fields[13] as String,
      createdBy: fields[14] as String?,
      isOfflineCreated: fields[15] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BillModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.receiptNumber)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.customerPhone)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.subtotal)
      ..writeByte(7)
      ..write(obj.taxRate)
      ..writeByte(8)
      ..write(obj.taxAmount)
      ..writeByte(9)
      ..write(obj.grandTotal)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.amountTendered)
      ..writeByte(12)
      ..write(obj.changeGiven)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.createdBy)
      ..writeByte(15)
      ..write(obj.isOfflineCreated);
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseModelAdapter extends TypeAdapter<PurchaseModel> {
  @override
  final int typeId = 34;

  @override
  PurchaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      supplierId: fields[2] as String,
      warehouseId: fields[3] as String,
      invoiceNumber: fields[4] as String,
      purchaseDate: fields[5] as DateTime,
      billDate: fields[6] as DateTime,
      quantity: fields[7] as int,
      price: fields[8] as double,
      discount: fields[9] as double,
      tax: fields[10] as double,
      paymentMethod: fields[11] as String,
      dueDate: fields[12] as DateTime,
      batchNumber: fields[13] as String,
      notes: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.supplierId)
      ..writeByte(3)
      ..write(obj.warehouseId)
      ..writeByte(4)
      ..write(obj.invoiceNumber)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.billDate)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.discount)
      ..writeByte(10)
      ..write(obj.tax)
      ..writeByte(11)
      ..write(obj.paymentMethod)
      ..writeByte(12)
      ..write(obj.dueDate)
      ..writeByte(13)
      ..write(obj.batchNumber)
      ..writeByte(14)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillItemModelAdapter extends TypeAdapter<BillItemModel> {
  @override
  final int typeId = 26;

  @override
  BillItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillItemModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      sku: fields[3] as String,
      barcode: fields[4] as String,
      variantId: fields[5] as String?,
      batchId: fields[6] as String?,
      quantity: fields[7] as double,
      unitPrice: fields[8] as double,
      mrp: fields[9] as double,
      discount: fields[10] as double,
      taxPercent: fields[11] as double,
      tax: fields[12] as double,
      total: fields[13] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BillItemModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.sku)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.variantId)
      ..writeByte(6)
      ..write(obj.batchId)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.unitPrice)
      ..writeByte(9)
      ..write(obj.mrp)
      ..writeByte(10)
      ..write(obj.discount)
      ..writeByte(11)
      ..write(obj.taxPercent)
      ..writeByte(12)
      ..write(obj.tax)
      ..writeByte(13)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

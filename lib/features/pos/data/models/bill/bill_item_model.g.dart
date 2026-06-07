// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillItemModelAdapter extends TypeAdapter<BillItemModel> {
  @override
  final int typeId = 1;

  @override
  BillItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillItemModel(
      productId: fields[0] as String,
      productName: fields[1] as String,
      sku: fields[2] as String,
      unitPrice: fields[3] as double,
      quantity: fields[4] as int,
      totalPrice: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BillItemModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.sku)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.totalPrice);
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

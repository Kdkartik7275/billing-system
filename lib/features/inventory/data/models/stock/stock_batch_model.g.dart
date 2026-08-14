// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_batch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockBatchModelAdapter extends TypeAdapter<StockBatchModel> {
  @override
  final int typeId = 16;

  @override
  StockBatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockBatchModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      warehouseId: fields[2] as String,
      batchNumber: fields[3] as String,
      quantity: fields[4] as double,
      manufactureDate: fields[5] as DateTime?,
      expiryDate: fields[6] as DateTime?,
      purchasePrice: fields[7] as double,
      receivedAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockBatchModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.warehouseId)
      ..writeByte(3)
      ..write(obj.batchNumber)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.manufactureDate)
      ..writeByte(6)
      ..write(obj.expiryDate)
      ..writeByte(7)
      ..write(obj.purchasePrice)
      ..writeByte(8)
      ..write(obj.receivedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockBatchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

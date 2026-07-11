// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_batch_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockBatchModelAdapter extends TypeAdapter<StockBatchModel> {
  @override
  final int typeId = 5;

  @override
  StockBatchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockBatchModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      quantityRemaining: fields[2] as int,
      purchasePrice: fields[3] as double,
      sellingPrice: fields[4] as double,
      receivedDate: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockBatchModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.quantityRemaining)
      ..writeByte(3)
      ..write(obj.purchasePrice)
      ..writeByte(4)
      ..write(obj.sellingPrice)
      ..writeByte(5)
      ..write(obj.receivedDate);
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

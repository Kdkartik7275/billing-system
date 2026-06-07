// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockTransactionModelAdapter extends TypeAdapter<StockTransactionModel> {
  @override
  final int typeId = 4;

  @override
  StockTransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockTransactionModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      type: fields[2] as StockTransactionType,
      previousStock: fields[3] as int,
      quantityChanged: fields[4] as int,
      newStock: fields[5] as int,
      purchasePrice: fields[6] as double?,
      referenceId: fields[7] as String?,
      notes: fields[8] as String?,
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockTransactionModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.previousStock)
      ..writeByte(4)
      ..write(obj.quantityChanged)
      ..writeByte(5)
      ..write(obj.newStock)
      ..writeByte(6)
      ..write(obj.purchasePrice)
      ..writeByte(7)
      ..write(obj.referenceId)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockTransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

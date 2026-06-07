// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_transactions_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockTransactionTypeAdapter extends TypeAdapter<StockTransactionType> {
  @override
  final int typeId = 3;

  @override
  StockTransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StockTransactionType.initialStock;
      case 1:
        return StockTransactionType.purchase;
      case 2:
        return StockTransactionType.sale;
      case 3:
        return StockTransactionType.returnStock;
      case 4:
        return StockTransactionType.damage;
      case 5:
        return StockTransactionType.adjustment;
      default:
        return StockTransactionType.initialStock;
    }
  }

  @override
  void write(BinaryWriter writer, StockTransactionType obj) {
    switch (obj) {
      case StockTransactionType.initialStock:
        writer.writeByte(0);
        break;
      case StockTransactionType.purchase:
        writer.writeByte(1);
        break;
      case StockTransactionType.sale:
        writer.writeByte(2);
        break;
      case StockTransactionType.returnStock:
        writer.writeByte(3);
        break;
      case StockTransactionType.damage:
        writer.writeByte(4);
        break;
      case StockTransactionType.adjustment:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockTransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

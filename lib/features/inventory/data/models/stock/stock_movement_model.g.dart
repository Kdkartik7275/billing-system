// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_movement_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockMovementModelAdapter extends TypeAdapter<StockMovementModel> {
  @override
  final int typeId = 17;

  @override
  StockMovementModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockMovementModel(
      id: fields[0] as String,
      productId: fields[1] as String,
      warehouseId: fields[2] as String,
      variantId: fields[3] as String?,
      batchId: fields[4] as String?,
      type: fields[5] as StockMovementTypeModel,
      quantityChange: fields[6] as double,
      resultingQuantity: fields[7] as double,
      reason: fields[8] as String?,
      referenceId: fields[9] as String?,
      performedByUserId: fields[10] as String?,
      createdAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StockMovementModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.warehouseId)
      ..writeByte(3)
      ..write(obj.variantId)
      ..writeByte(4)
      ..write(obj.batchId)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.quantityChange)
      ..writeByte(7)
      ..write(obj.resultingQuantity)
      ..writeByte(8)
      ..write(obj.reason)
      ..writeByte(9)
      ..write(obj.referenceId)
      ..writeByte(10)
      ..write(obj.performedByUserId)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockMovementModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StockMovementTypeModelAdapter
    extends TypeAdapter<StockMovementTypeModel> {
  @override
  final int typeId = 18;

  @override
  StockMovementTypeModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return StockMovementTypeModel.purchaseIn;
      case 1:
        return StockMovementTypeModel.saleOut;
      case 2:
        return StockMovementTypeModel.transferIn;
      case 3:
        return StockMovementTypeModel.transferOut;
      case 4:
        return StockMovementTypeModel.adjustment;
      case 5:
        return StockMovementTypeModel.returnIn;
      case 6:
        return StockMovementTypeModel.returnOut;
      case 7:
        return StockMovementTypeModel.damaged;
      case 8:
        return StockMovementTypeModel.expired;
      default:
        return StockMovementTypeModel.purchaseIn;
    }
  }

  @override
  void write(BinaryWriter writer, StockMovementTypeModel obj) {
    switch (obj) {
      case StockMovementTypeModel.purchaseIn:
        writer.writeByte(0);
        break;
      case StockMovementTypeModel.saleOut:
        writer.writeByte(1);
        break;
      case StockMovementTypeModel.transferIn:
        writer.writeByte(2);
        break;
      case StockMovementTypeModel.transferOut:
        writer.writeByte(3);
        break;
      case StockMovementTypeModel.adjustment:
        writer.writeByte(4);
        break;
      case StockMovementTypeModel.returnIn:
        writer.writeByte(5);
        break;
      case StockMovementTypeModel.returnOut:
        writer.writeByte(6);
        break;
      case StockMovementTypeModel.damaged:
        writer.writeByte(7);
        break;
      case StockMovementTypeModel.expired:
        writer.writeByte(8);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockMovementTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

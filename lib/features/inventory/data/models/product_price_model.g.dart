// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_price_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductPriceModelAdapter extends TypeAdapter<ProductPriceModel> {
  @override
  final int typeId = 6;

  @override
  ProductPriceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductPriceModel(
      purchasePrice: fields[0] as double,
      sellingPrice: fields[1] as double,
      mrp: fields[2] as double?,
      wholesalePrice: fields[3] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductPriceModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.purchasePrice)
      ..writeByte(1)
      ..write(obj.sellingPrice)
      ..writeByte(2)
      ..write(obj.mrp)
      ..writeByte(3)
      ..write(obj.wholesalePrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductPriceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

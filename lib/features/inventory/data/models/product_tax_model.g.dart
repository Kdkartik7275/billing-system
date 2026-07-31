// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_tax_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductTaxModelAdapter extends TypeAdapter<ProductTaxModel> {
  @override
  final int typeId = 7;

  @override
  ProductTaxModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductTaxModel(
      gstPercent: fields[0] as double,
      type: fields[1] as TaxTypeModel,
      hsnCode: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductTaxModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.gstPercent)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.hsnCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTaxModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

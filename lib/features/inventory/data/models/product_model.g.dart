// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 5;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      sku: fields[3] as String,
      barcode: fields[4] as String,
      categoryId: fields[5] as String,
      brandId: fields[6] as String?,
      unitId: fields[7] as String,
      primarySupplierId: fields[8] as String?,
      price: fields[9] as ProductPriceModel,
      tax: fields[10] as ProductTaxModel,
      settings: fields[11] as ProductSettingsModel,
      variants: (fields[12] as List).cast<ProductVariantModel>(),
      images: (fields[13] as List).cast<ProductImageModel>(),
      createdAt: fields[14] as DateTime,
      updatedAt: fields[15] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.sku)
      ..writeByte(4)
      ..write(obj.barcode)
      ..writeByte(5)
      ..write(obj.categoryId)
      ..writeByte(6)
      ..write(obj.brandId)
      ..writeByte(7)
      ..write(obj.unitId)
      ..writeByte(8)
      ..write(obj.primarySupplierId)
      ..writeByte(9)
      ..write(obj.price)
      ..writeByte(10)
      ..write(obj.tax)
      ..writeByte(11)
      ..write(obj.settings)
      ..writeByte(12)
      ..write(obj.variants)
      ..writeByte(13)
      ..write(obj.images)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

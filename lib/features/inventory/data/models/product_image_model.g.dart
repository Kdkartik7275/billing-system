// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductImageModelAdapter extends TypeAdapter<ProductImageModel> {
  @override
  final int typeId = 10;

  @override
  ProductImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductImageModel(
      url: fields[0] as String,
      isPrimary: fields[1] as bool,
      altText: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductImageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.isPrimary)
      ..writeByte(2)
      ..write(obj.altText);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

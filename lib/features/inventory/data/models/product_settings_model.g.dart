// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductSettingsModelAdapter extends TypeAdapter<ProductSettingsModel> {
  @override
  final int typeId = 8;

  @override
  ProductSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductSettingsModel(
      lowStockThreshold: fields[0] as int,
      allowNegativeStock: fields[1] as bool,
      isActive: fields[2] as bool,
      trackBatches: fields[3] as bool,
      trackExpiry: fields[4] as bool,
      isLoyaltyEligible: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductSettingsModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.lowStockThreshold)
      ..writeByte(1)
      ..write(obj.allowNegativeStock)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.trackBatches)
      ..writeByte(4)
      ..write(obj.trackExpiry)
      ..writeByte(5)
      ..write(obj.isLoyaltyEligible);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

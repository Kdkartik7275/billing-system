// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessDetailsModelAdapter extends TypeAdapter<BusinessDetailsModel> {
  @override
  final int typeId = 29;

  @override
  BusinessDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessDetailsModel(
      gstNumber: fields[0] as String?,
      panNumber: fields[1] as String?,
      shopImage: fields[2] as String?,
      businessType: fields[3] as String?,
      state: fields[4] as String?,
      fssaiLicense: fields[5] as String?,
      currency: fields[6] as String,
      financialYearStart: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessDetailsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.gstNumber)
      ..writeByte(1)
      ..write(obj.panNumber)
      ..writeByte(2)
      ..write(obj.shopImage)
      ..writeByte(3)
      ..write(obj.businessType)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.fssaiLicense)
      ..writeByte(6)
      ..write(obj.currency)
      ..writeByte(7)
      ..write(obj.financialYearStart);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

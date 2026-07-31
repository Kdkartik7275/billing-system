// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxTypeModelAdapter extends TypeAdapter<TaxTypeModel> {
  @override
  final int typeId = 11;

  @override
  TaxTypeModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaxTypeModel.exclusive;
      case 1:
        return TaxTypeModel.inclusive;
      case 2:
        return TaxTypeModel.exempt;
      default:
        return TaxTypeModel.exclusive;
    }
  }

  @override
  void write(BinaryWriter writer, TaxTypeModel obj) {
    switch (obj) {
      case TaxTypeModel.exclusive:
        writer.writeByte(0);
        break;
      case TaxTypeModel.inclusive:
        writer.writeByte(1);
        break;
      case TaxTypeModel.exempt:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

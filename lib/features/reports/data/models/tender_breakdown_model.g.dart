// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tender_breakdown_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TenderBreakdownModelAdapter extends TypeAdapter<TenderBreakdownModel> {
  @override
  final int typeId = 40;

  @override
  TenderBreakdownModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TenderBreakdownModel(
      cash: fields[0] as double,
      upi: fields[1] as double,
      card: fields[2] as double,
      wallet: fields[3] as double,
      other: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TenderBreakdownModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.cash)
      ..writeByte(1)
      ..write(obj.upi)
      ..writeByte(2)
      ..write(obj.card)
      ..writeByte(3)
      ..write(obj.wallet)
      ..writeByte(4)
      ..write(obj.other);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TenderBreakdownModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

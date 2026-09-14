// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesSummaryModelAdapter extends TypeAdapter<SalesSummaryModel> {
  @override
  final int typeId = 38;

  @override
  SalesSummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesSummaryModel(
      totalSales: fields[0] as double,
      totalBills: fields[1] as int,
      voidAmount: fields[2] as double,
      voidCount: fields[3] as int,
      discountsGiven: fields[4] as double,
      discountedBillCount: fields[5] as int,
      refunds: fields[6] as double,
      refundCount: fields[7] as int,
      taxAmount: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SalesSummaryModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.totalSales)
      ..writeByte(1)
      ..write(obj.totalBills)
      ..writeByte(2)
      ..write(obj.voidAmount)
      ..writeByte(3)
      ..write(obj.voidCount)
      ..writeByte(4)
      ..write(obj.discountsGiven)
      ..writeByte(5)
      ..write(obj.discountedBillCount)
      ..writeByte(6)
      ..write(obj.refunds)
      ..writeByte(7)
      ..write(obj.refundCount)
      ..writeByte(8)
      ..write(obj.taxAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesSummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

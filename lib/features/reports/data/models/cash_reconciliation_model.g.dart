// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_reconciliation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CashReconciliationModelAdapter
    extends TypeAdapter<CashReconciliationModel> {
  @override
  final int typeId = 37;

  @override
  CashReconciliationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CashReconciliationModel(
      openingCashFloat: fields[0] as double,
      cashSales: fields[1] as double,
      cashRefunds: fields[2] as double,
      payouts: fields[3] as double,
      expectedCash: fields[4] as double,
      countedCash: fields[5] as double?,
      variance: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, CashReconciliationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.openingCashFloat)
      ..writeByte(1)
      ..write(obj.cashSales)
      ..writeByte(2)
      ..write(obj.cashRefunds)
      ..writeByte(3)
      ..write(obj.payouts)
      ..writeByte(4)
      ..write(obj.expectedCash)
      ..writeByte(5)
      ..write(obj.countedCash)
      ..writeByte(6)
      ..write(obj.variance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CashReconciliationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

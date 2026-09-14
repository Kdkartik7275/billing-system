// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportModelAdapter extends TypeAdapter<ReportModel> {
  @override
  final int typeId = 39;

  @override
  ReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportModel(
      id: fields[0] as String,
      shopId: fields[1] as String,
      businessDate: fields[2] as DateTime,
      status: fields[3] as String,
      closedAt: fields[4] as DateTime?,
      closedBy: fields[5] as String?,
      cashReconciliation: fields[6] as CashReconciliationModel,
      tenderBreakdown: fields[7] as TenderBreakdownModel,
      salesSummary: fields[8] as SalesSummaryModel,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReportModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shopId)
      ..writeByte(2)
      ..write(obj.businessDate)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.closedAt)
      ..writeByte(5)
      ..write(obj.closedBy)
      ..writeByte(6)
      ..write(obj.cashReconciliation)
      ..writeByte(7)
      ..write(obj.tenderBreakdown)
      ..writeByte(8)
      ..write(obj.salesSummary)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentSummaryModelAdapter extends TypeAdapter<PaymentSummaryModel> {
  @override
  final int typeId = 25;

  @override
  PaymentSummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentSummaryModel(
      payments: (fields[0] as List).cast<PaymentModel>(),
      paidAmount: fields[1] as double,
      changeAmount: fields[2] as double,
      pendingAmount: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentSummaryModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.payments)
      ..writeByte(1)
      ..write(obj.paidAmount)
      ..writeByte(2)
      ..write(obj.changeAmount)
      ..writeByte(3)
      ..write(obj.pendingAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentSummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

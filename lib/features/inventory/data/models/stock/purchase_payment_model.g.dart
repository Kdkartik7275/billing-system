// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_payment_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchasePaymentModelAdapter extends TypeAdapter<PurchasePaymentModel> {
  @override
  final int typeId = 41;

  @override
  PurchasePaymentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchasePaymentModel(
      id: fields[0] as String,
      purchaseId: fields[1] as String,
      supplierId: fields[2] as String,
      amount: fields[3] as double,
      paymentDate: fields[4] as DateTime,
      paymentMethod: fields[5] as String,
      referenceNumber: fields[6] as String?,
      notes: fields[7] as String?,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PurchasePaymentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.purchaseId)
      ..writeByte(2)
      ..write(obj.supplierId)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paymentDate)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.referenceNumber)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchasePaymentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

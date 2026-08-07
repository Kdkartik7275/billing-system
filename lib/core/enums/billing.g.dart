// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillStatusAdapter extends TypeAdapter<BillStatus> {
  @override
  final int typeId = 20;

  @override
  BillStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BillStatus.pending;
      case 1:
        return BillStatus.completed;
      case 2:
        return BillStatus.cancelled;
      case 3:
        return BillStatus.refunded;
      default:
        return BillStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, BillStatus obj) {
    switch (obj) {
      case BillStatus.pending:
        writer.writeByte(0);
        break;
      case BillStatus.completed:
        writer.writeByte(1);
        break;
      case BillStatus.cancelled:
        writer.writeByte(2);
        break;
      case BillStatus.refunded:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PaymentMethodAdapter extends TypeAdapter<PaymentMethod> {
  @override
  final int typeId = 21;

  @override
  PaymentMethod read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentMethod.cash;
      case 1:
        return PaymentMethod.card;
      case 2:
        return PaymentMethod.upi;
      case 3:
        return PaymentMethod.wallet;
      case 4:
        return PaymentMethod.other;
      default:
        return PaymentMethod.cash;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentMethod obj) {
    switch (obj) {
      case PaymentMethod.cash:
        writer.writeByte(0);
        break;
      case PaymentMethod.card:
        writer.writeByte(1);
        break;
      case PaymentMethod.upi:
        writer.writeByte(2);
        break;
      case PaymentMethod.wallet:
        writer.writeByte(3);
        break;
      case PaymentMethod.other:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

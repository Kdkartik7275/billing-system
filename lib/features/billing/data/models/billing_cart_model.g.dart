// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillingCartModelAdapter extends TypeAdapter<BillingCartModel> {
  @override
  final int typeId = 28;

  @override
  BillingCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillingCartModel(
      items: (fields[0] as List).cast<BillItemModel>(),
      customer: fields[1] as CustomerModel?,
      coupon: fields[2] as CouponModel?,
    );
  }

  @override
  void write(BinaryWriter writer, BillingCartModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.coupon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillingCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

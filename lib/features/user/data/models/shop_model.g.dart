// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopModelAdapter extends TypeAdapter<ShopModel> {
  @override
  final int typeId = 4;

  @override
  ShopModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopModel(
      id: fields[0] as String,
      shopName: fields[1] as String,
      ownerUid: fields[2] as String,
      ownerName: fields[3] as String,
      ownerEmail: fields[4] as String,
      ownerPhone: fields[5] as String,
      address: fields[6] as String,
      isActive: fields[7] as bool,
      plan: fields[8] as String,
      subscriptionExpiry: fields[9] as DateTime?,
      firebaseConfig: fields[10] as FirebaseConfigModel,
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ShopModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shopName)
      ..writeByte(2)
      ..write(obj.ownerUid)
      ..writeByte(3)
      ..write(obj.ownerName)
      ..writeByte(4)
      ..write(obj.ownerEmail)
      ..writeByte(5)
      ..write(obj.ownerPhone)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.plan)
      ..writeByte(9)
      ..write(obj.subscriptionExpiry)
      ..writeByte(10)
      ..write(obj.firebaseConfig)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

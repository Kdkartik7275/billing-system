// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'held_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HeldCartModelAdapter extends TypeAdapter<HeldCartModel> {
  @override
  final int typeId = 35;

  @override
  HeldCartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeldCartModel(
      id: fields[0] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
      items: (fields[4] as List).cast<BillItemModel>(),
      label: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HeldCartModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeldCartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

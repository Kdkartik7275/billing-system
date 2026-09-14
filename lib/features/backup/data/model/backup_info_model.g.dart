// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BackupInfoModelAdapter extends TypeAdapter<BackupInfoModel> {
  @override
  final int typeId = 36;

  @override
  BackupInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BackupInfoModel(
      filePath: fields[0] as String,
      appVersion: fields[1] as String,
      formatVersion: fields[2] as int,
      createdAt: fields[3] as DateTime,
      shopId: fields[4] as String?,
      shopName: fields[5] as String?,
      productsCount: fields[6] as int,
      categoriesCount: fields[7] as int,
      customersCount: fields[8] as int,
      suppliersCount: fields[9] as int,
      billsCount: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BackupInfoModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.appVersion)
      ..writeByte(2)
      ..write(obj.formatVersion)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.shopId)
      ..writeByte(5)
      ..write(obj.shopName)
      ..writeByte(6)
      ..write(obj.productsCount)
      ..writeByte(7)
      ..write(obj.categoriesCount)
      ..writeByte(8)
      ..write(obj.customersCount)
      ..writeByte(9)
      ..write(obj.suppliersCount)
      ..writeByte(10)
      ..write(obj.billsCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackupInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

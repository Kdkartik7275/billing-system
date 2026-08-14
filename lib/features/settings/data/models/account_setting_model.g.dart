// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountSettingsModelAdapter extends TypeAdapter<AccountSettingsModel> {
  @override
  final int typeId = 30;

  @override
  AccountSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountSettingsModel(
      language: fields[0] as String,
      locale: fields[1] as String,
      timeZone: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AccountSettingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.language)
      ..writeByte(1)
      ..write(obj.locale)
      ..writeByte(2)
      ..write(obj.timeZone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

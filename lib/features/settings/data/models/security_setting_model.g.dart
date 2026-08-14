// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SecuritySettingsModelAdapter extends TypeAdapter<SecuritySettingsModel> {
  @override
  final int typeId = 31;

  @override
  SecuritySettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SecuritySettingsModel(
      twoFactorAuthentication: fields[0] as bool,
      biometricLogin: fields[1] as bool,
      passwordLastChanged: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SecuritySettingsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.twoFactorAuthentication)
      ..writeByte(1)
      ..write(obj.biometricLogin)
      ..writeByte(2)
      ..write(obj.passwordLastChanged);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecuritySettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirebaseConfigModelAdapter extends TypeAdapter<FirebaseConfigModel> {
  @override
  final int typeId = 3;

  @override
  FirebaseConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirebaseConfigModel(
      androidApiKey: fields[0] as String,
      iosApiKey: fields[1] as String,
      webApiKey: fields[2] as String,
      androidAppId: fields[3] as String,
      iosAppId: fields[4] as String,
      webAppId: fields[5] as String,
      projectId: fields[6] as String,
      messagingSenderId: fields[7] as String,
      storageBucket: fields[8] as String,
      authDomain: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FirebaseConfigModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.androidApiKey)
      ..writeByte(1)
      ..write(obj.iosApiKey)
      ..writeByte(2)
      ..write(obj.webApiKey)
      ..writeByte(3)
      ..write(obj.androidAppId)
      ..writeByte(4)
      ..write(obj.iosAppId)
      ..writeByte(5)
      ..write(obj.webAppId)
      ..writeByte(6)
      ..write(obj.projectId)
      ..writeByte(7)
      ..write(obj.messagingSenderId)
      ..writeByte(8)
      ..write(obj.storageBucket)
      ..writeByte(9)
      ..write(obj.authDomain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FirebaseConfigModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

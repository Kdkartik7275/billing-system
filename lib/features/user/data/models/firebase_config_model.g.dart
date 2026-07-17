// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FirebaseConfigModelAdapter extends TypeAdapter<FirebaseConfigModel> {
  @override
  final int typeId = 31;

  @override
  FirebaseConfigModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FirebaseConfigModel(
      androidApiKey: fields[0] as String,
      iosApiKey: fields[1] as String,
      androidAppId: fields[2] as String,
      iosAppId: fields[3] as String,
      projectId: fields[4] as String,
      messagingSenderId: fields[5] as String,
      storageBucket: fields[6] as String,
      databaseURL: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FirebaseConfigModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.androidApiKey)
      ..writeByte(1)
      ..write(obj.iosApiKey)
      ..writeByte(2)
      ..write(obj.androidAppId)
      ..writeByte(3)
      ..write(obj.iosAppId)
      ..writeByte(4)
      ..write(obj.projectId)
      ..writeByte(5)
      ..write(obj.messagingSenderId)
      ..writeByte(6)
      ..write(obj.storageBucket)
      ..writeByte(7)
      ..write(obj.databaseURL);
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

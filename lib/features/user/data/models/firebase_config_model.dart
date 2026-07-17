import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:hive/hive.dart';

part 'firebase_config_model.g.dart';

@HiveType(typeId: 31)
class FirebaseConfigModel {
  @HiveField(0)
  final String androidApiKey;

  @HiveField(1)
  final String iosApiKey;

  @HiveField(2)
  final String androidAppId;

  @HiveField(3)
  final String iosAppId;

  @HiveField(4)
  final String projectId;

  @HiveField(5)
  final String messagingSenderId;

  @HiveField(6)
  final String storageBucket;

  @HiveField(7)
  final String? databaseURL;

  const FirebaseConfigModel({
    required this.androidApiKey,
    required this.iosApiKey,
    required this.androidAppId,
    required this.iosAppId,
    required this.projectId,
    required this.messagingSenderId,
    required this.storageBucket,
    this.databaseURL,
  });

  factory FirebaseConfigModel.fromJson(Map<String, dynamic> json) {
    return FirebaseConfigModel(
      androidApiKey: json['androidApiKey'] ?? '',
      iosApiKey: json['iosApiKey'] ?? '',
      androidAppId: json['androidAppId'] ?? '',
      iosAppId: json['iosAppId'] ?? '',
      projectId: json['projectId'] ?? '',
      messagingSenderId: json['messagingSenderId'] ?? '',
      storageBucket: json['storageBucket'] ?? '',
      databaseURL: json['databaseURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'androidApiKey': androidApiKey,
      'iosApiKey': iosApiKey,
      'androidAppId': androidAppId,
      'iosAppId': iosAppId,
      'projectId': projectId,
      'messagingSenderId': messagingSenderId,
      'storageBucket': storageBucket,
      'databaseURL': databaseURL,
    };
  }

  FirebaseConfigEntity toEntity() {
    return FirebaseConfigEntity(
      androidApiKey: androidApiKey,
      iosApiKey: iosApiKey,
      androidAppId: androidAppId,
      iosAppId: iosAppId,
      projectId: projectId,
      messagingSenderId: messagingSenderId,
      storageBucket: storageBucket,
      databaseURL: databaseURL,
    );
  }

  factory FirebaseConfigModel.fromEntity(FirebaseConfigEntity entity) {
    return FirebaseConfigModel(
      androidApiKey: entity.androidApiKey,
      iosApiKey: entity.iosApiKey,
      androidAppId: entity.androidAppId,
      iosAppId: entity.iosAppId,
      projectId: entity.projectId,
      messagingSenderId: entity.messagingSenderId,
      storageBucket: entity.storageBucket,
      databaseURL: entity.databaseURL,
    );
  }
}
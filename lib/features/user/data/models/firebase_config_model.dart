import 'package:billing_system/features/user/domain/entity/shop_entity.dart';
import 'package:hive/hive.dart';

part 'firebase_config_model.g.dart';

@HiveType(typeId: 3)
class FirebaseConfigModel {
  @HiveField(0)
  final String androidApiKey;

  @HiveField(1)
  final String iosApiKey;

  @HiveField(2)
  final String webApiKey;

  @HiveField(3)
  final String androidAppId;

  @HiveField(4)
  final String iosAppId;

  @HiveField(5)
  final String webAppId;

  @HiveField(6)
  final String projectId;

  @HiveField(7)
  final String messagingSenderId;

  @HiveField(8)
  final String storageBucket;

  @HiveField(9)
  final String authDomain;

  const FirebaseConfigModel({
    required this.androidApiKey,
    required this.iosApiKey,
    required this.webApiKey,
    required this.androidAppId,
    required this.iosAppId,
    required this.webAppId,
    required this.projectId,
    required this.messagingSenderId,
    required this.storageBucket,
    required this.authDomain,
  });

  factory FirebaseConfigModel.fromJson(Map<String, dynamic> json) {
    return FirebaseConfigModel(
      androidApiKey: json['androidApiKey'] ?? '',
      iosApiKey: json['iosApiKey'] ?? '',
      webApiKey: json['webApiKey'] ?? '',
      androidAppId: json['androidAppId'] ?? '',
      iosAppId: json['iosAppId'] ?? '',
      webAppId: json['webAppId'] ?? '',
      projectId: json['projectId'] ?? '',
      messagingSenderId: json['messagingSenderId'] ?? '',
      storageBucket: json['storageBucket'] ?? '',
      authDomain: json['authDomain'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'androidApiKey': androidApiKey,
      'iosApiKey': iosApiKey,
      'webApiKey': webApiKey,
      'androidAppId': androidAppId,
      'iosAppId': iosAppId,
      'webAppId': webAppId,
      'projectId': projectId,
      'messagingSenderId': messagingSenderId,
      'storageBucket': storageBucket,
      'authDomain': authDomain,
    };
  }

  FirebaseConfigEntity toEntity() {
    return FirebaseConfigEntity(
      androidApiKey: androidApiKey,
      iosApiKey: iosApiKey,
      webApiKey: webApiKey,
      androidAppId: androidAppId,
      iosAppId: iosAppId,
      webAppId: webAppId,
      projectId: projectId,
      messagingSenderId: messagingSenderId,
      storageBucket: storageBucket,
      authDomain: authDomain,
    );
  }

  factory FirebaseConfigModel.fromEntity(FirebaseConfigEntity entity) {
    return FirebaseConfigModel(
      androidApiKey: entity.androidApiKey,
      iosApiKey: entity.iosApiKey,
      webApiKey: entity.webApiKey,
      androidAppId: entity.androidAppId,
      iosAppId: entity.iosAppId,
      webAppId: entity.webAppId,
      projectId: entity.projectId,
      messagingSenderId: entity.messagingSenderId,
      storageBucket: entity.storageBucket,
      authDomain: entity.authDomain,
    );
  }
}

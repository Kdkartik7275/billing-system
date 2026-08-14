import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/settings/domain/entities/security_setting_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'security_setting_model.g.dart';

@HiveType(typeId: HiveTypeIds.securitySettingsModel)
class SecuritySettingsModel {
  @HiveField(0)
  final bool twoFactorAuthentication;

  @HiveField(1)
  final bool biometricLogin;

  @HiveField(2)
  final DateTime? passwordLastChanged;

  const SecuritySettingsModel({
    this.twoFactorAuthentication = false,
    this.biometricLogin = false,
    this.passwordLastChanged,
  });

  factory SecuritySettingsModel.fromEntity(SecuritySettingsEntity entity) {
    return SecuritySettingsModel(
      twoFactorAuthentication: entity.twoFactorAuthentication,
      biometricLogin: entity.biometricLogin,
      passwordLastChanged: entity.passwordLastChanged,
    );
  }

  SecuritySettingsEntity toEntity() {
    return SecuritySettingsEntity(
      twoFactorAuthentication: twoFactorAuthentication,
      biometricLogin: biometricLogin,
      passwordLastChanged: passwordLastChanged,
    );
  }

  SecuritySettingsModel copyWith({
    bool? twoFactorAuthentication,
    bool? biometricLogin,
    DateTime? passwordLastChanged,
  }) {
    return SecuritySettingsModel(
      twoFactorAuthentication:
          twoFactorAuthentication ?? this.twoFactorAuthentication,
      biometricLogin: biometricLogin ?? this.biometricLogin,
      passwordLastChanged:
          passwordLastChanged ?? this.passwordLastChanged,
    );
  }
}
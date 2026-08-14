import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/settings/domain/entities/account_setting_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'account_setting_model.g.dart';

@HiveType(typeId: HiveTypeIds.accountSettingsModel)
class AccountSettingsModel {
  @HiveField(0)
  final String language;

  @HiveField(1)
  final String locale;

  @HiveField(2)
  final String timeZone;

  const AccountSettingsModel({
    this.language = 'English',
    this.locale = 'en-IN',
    this.timeZone = 'Asia/Kolkata',
  });

  factory AccountSettingsModel.fromEntity(AccountSettingsEntity entity) {
    return AccountSettingsModel(
      language: entity.language,
      locale: entity.locale,
      timeZone: entity.timeZone,
    );
  }

  AccountSettingsEntity toEntity() {
    return AccountSettingsEntity(
      language: language,
      locale: locale,
      timeZone: timeZone,
    );
  }

  AccountSettingsModel copyWith({
    String? language,
    String? locale,
    String? timeZone,
  }) {
    return AccountSettingsModel(
      language: language ?? this.language,
      locale: locale ?? this.locale,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}
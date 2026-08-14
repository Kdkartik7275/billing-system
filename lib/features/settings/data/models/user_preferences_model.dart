import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/settings/domain/entities/user_prefernce_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_preferences_model.g.dart';

@HiveType(typeId: HiveTypeIds.userPreferencesModel)
class UserPreferencesModel {
  @HiveField(0)
  final bool notificationsEnabled;

  @HiveField(1)
  final bool soundEnabled;

  @HiveField(2)
  final bool showProductImages;

  @HiveField(3)
  final bool autoPrintReceipt;

  @HiveField(4)
  final bool confirmBeforeDelete;

  const UserPreferencesModel({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.showProductImages = true,
    this.autoPrintReceipt = true,
    this.confirmBeforeDelete = true,
  });

  factory UserPreferencesModel.fromEntity(UserPreferencesEntity entity) {
    return UserPreferencesModel(
      notificationsEnabled: entity.notificationsEnabled,
      soundEnabled: entity.soundEnabled,
      showProductImages: entity.showProductImages,
      autoPrintReceipt: entity.autoPrintReceipt,
      confirmBeforeDelete: entity.confirmBeforeDelete,
    );
  }

  UserPreferencesEntity toEntity() {
    return UserPreferencesEntity(
      notificationsEnabled: notificationsEnabled,
      soundEnabled: soundEnabled,
      showProductImages: showProductImages,
      autoPrintReceipt: autoPrintReceipt,
      confirmBeforeDelete: confirmBeforeDelete,
    );
  }

  UserPreferencesModel copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? showProductImages,
    bool? autoPrintReceipt,
    bool? confirmBeforeDelete,
  }) {
    return UserPreferencesModel(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      showProductImages: showProductImages ?? this.showProductImages,
      autoPrintReceipt: autoPrintReceipt ?? this.autoPrintReceipt,
      confirmBeforeDelete: confirmBeforeDelete ?? this.confirmBeforeDelete,
    );
  }
}

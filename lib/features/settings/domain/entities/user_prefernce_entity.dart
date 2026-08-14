class UserPreferencesEntity {
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool showProductImages;
  final bool autoPrintReceipt;
  final bool confirmBeforeDelete;

  const UserPreferencesEntity({
    this.notificationsEnabled = true,
    this.soundEnabled = true,
    this.showProductImages = true,
    this.autoPrintReceipt = true,
    this.confirmBeforeDelete = true,
  });

  UserPreferencesEntity copyWith({
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? showProductImages,
    bool? autoPrintReceipt,
    bool? confirmBeforeDelete,
  }) {
    return UserPreferencesEntity(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      showProductImages: showProductImages ?? this.showProductImages,
      autoPrintReceipt: autoPrintReceipt ?? this.autoPrintReceipt,
      confirmBeforeDelete: confirmBeforeDelete ?? this.confirmBeforeDelete,
    );
  }
}

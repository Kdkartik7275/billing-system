class AccountSettingsEntity {
  final String language;
  final String locale;
  final String timeZone;

  const AccountSettingsEntity({
    this.language = 'English',
    this.locale = 'en-IN',
    this.timeZone = 'Asia/Kolkata',
  });

  AccountSettingsEntity copyWith({
    String? language,
    String? locale,
    String? timeZone,
  }) {
    return AccountSettingsEntity(
      language: language ?? this.language,
      locale: locale ?? this.locale,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}

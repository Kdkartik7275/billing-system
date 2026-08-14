class SecuritySettingsEntity {
  final bool twoFactorAuthentication;
  final bool biometricLogin;
  final DateTime? passwordLastChanged;

  const SecuritySettingsEntity({
    this.twoFactorAuthentication = false,
    this.biometricLogin = false,
    this.passwordLastChanged,
  });

  SecuritySettingsEntity copyWith({
    bool? twoFactorAuthentication,
    bool? biometricLogin,
    DateTime? passwordLastChanged,
  }) {
    return SecuritySettingsEntity(
      twoFactorAuthentication:
          twoFactorAuthentication ?? this.twoFactorAuthentication,
      biometricLogin: biometricLogin ?? this.biometricLogin,
      passwordLastChanged: passwordLastChanged ?? this.passwordLastChanged,
    );
  }
}

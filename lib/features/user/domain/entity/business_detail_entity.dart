class BusinessDetailsEntity {
  final String? gstNumber;
  final String? panNumber;
  final String? shopImage;

  final String? businessType;
  final String? state;

  final String? fssaiLicense;

  final String currency;
  final String financialYearStart;

  const BusinessDetailsEntity({
    this.gstNumber,
    this.panNumber,
    this.shopImage,
    this.businessType,
    this.state,
    this.fssaiLicense,
    this.currency = 'INR',
    this.financialYearStart = '1st April',
  });

  BusinessDetailsEntity copyWith({
    String? gstNumber,
    String? panNumber,
    String? shopImage,
    String? businessType,
    String? state,
    String? fssaiLicense,
    String? currency,
    String? financialYearStart,
  }) {
    return BusinessDetailsEntity(
      gstNumber: gstNumber ?? this.gstNumber,
      panNumber: panNumber ?? this.panNumber,
      shopImage: shopImage ?? this.shopImage,
      businessType: businessType ?? this.businessType,
      state: state ?? this.state,
      fssaiLicense: fssaiLicense ?? this.fssaiLicense,
      currency: currency ?? this.currency,
      financialYearStart: financialYearStart ?? this.financialYearStart,
    );
  }
}

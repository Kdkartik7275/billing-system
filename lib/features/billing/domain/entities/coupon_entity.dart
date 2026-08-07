class CouponEntity {
  final String code;
  final double value;

  final bool isPercentage;

  const CouponEntity({
    required this.code,
    required this.value,
    required this.isPercentage,
  });

  CouponEntity copyWith({String? code, double? value, bool? isPercentage}) {
    return CouponEntity(
      code: code ?? this.code,
      value: value ?? this.value,
      isPercentage: isPercentage ?? this.isPercentage,
    );
  }
}

import 'package:billing_system/features/billing/domain/entities/coupon_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'coupon_model.g.dart';

@HiveType(typeId: 23)
class CouponModel extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final double value;

  @HiveField(2)
  final bool isPercentage;

  CouponModel({
    required this.code,
    required this.value,
    required this.isPercentage,
  });

  factory CouponModel.fromEntity(CouponEntity entity) {
    return CouponModel(
      code: entity.code,
      value: entity.value,
      isPercentage: entity.isPercentage,
    );
  }

  CouponEntity toEntity() {
    return CouponEntity(code: code, value: value, isPercentage: isPercentage);
  }

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      code: json['code'] as String,
      value: (json['value'] as num).toDouble(),
      isPercentage: json['isPercentage'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'value': value, 'isPercentage': isPercentage};
  }

  CouponModel copyWith({String? code, double? value, bool? isPercentage}) {
    return CouponModel(
      code: code ?? this.code,
      value: value ?? this.value,
      isPercentage: isPercentage ?? this.isPercentage,
    );
  }
}

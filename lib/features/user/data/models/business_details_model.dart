import 'package:billing_system/features/user/domain/entity/business_detail_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:billing_system/core/config/constants/hive_type_ids.dart';

part 'business_details_model.g.dart';

@HiveType(typeId: HiveTypeIds.businessDetailsModel)
class BusinessDetailsModel extends HiveObject {
  @HiveField(0)
  final String? gstNumber;

  @HiveField(1)
  final String? panNumber;

  @HiveField(2)
  final String? shopImage;

  @HiveField(3)
  final String? businessType;

  @HiveField(4)
  final String? state;

  @HiveField(5)
  final String? fssaiLicense;

  @HiveField(6)
  final String currency;

  @HiveField(7)
  final String financialYearStart;

  BusinessDetailsModel({
    this.gstNumber,
    this.panNumber,
    this.shopImage,
    this.businessType,
    this.state,
    this.fssaiLicense,
    this.currency = 'INR',
    this.financialYearStart = '1st April',
  });

  factory BusinessDetailsModel.fromEntity(BusinessDetailsEntity entity) {
    return BusinessDetailsModel(
      gstNumber: entity.gstNumber,
      panNumber: entity.panNumber,
      shopImage: entity.shopImage,
      businessType: entity.businessType,
      state: entity.state,
      fssaiLicense: entity.fssaiLicense,
      currency: entity.currency,
      financialYearStart: entity.financialYearStart,
    );
  }

  BusinessDetailsEntity toEntity() {
    return BusinessDetailsEntity(
      gstNumber: gstNumber,
      panNumber: panNumber,
      shopImage: shopImage,
      businessType: businessType,
      state: state,
      fssaiLicense: fssaiLicense,
      currency: currency,
      financialYearStart: financialYearStart,
    );
  }

  factory BusinessDetailsModel.fromJson(Map<String, dynamic> json) {
    return BusinessDetailsModel(
      gstNumber: json['gstNumber'] as String?,
      panNumber: json['panNumber'] as String?,
      shopImage: json['shopImage'] as String?,
      businessType: json['businessType'] as String?,
      state: json['state'] as String?,
      fssaiLicense: json['fssaiLicense'] as String?,
      currency: json['currency'] as String? ?? 'INR',
      financialYearStart: json['financialYearStart'] as String? ?? '1st April',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gstNumber': gstNumber,
      'panNumber': panNumber,
      'shopImage': shopImage,
      'businessType': businessType,
      'state': state,
      'fssaiLicense': fssaiLicense,
      'currency': currency,
      'financialYearStart': financialYearStart,
    };
  }
}

import 'package:billing_system/core/config/constants/hive_type_ids.dart';
import 'package:billing_system/features/inventory/data/models/tax_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/value_objects/product_tax.dart';

part 'product_tax_model.g.dart';

@HiveType(typeId: HiveTypeIds.productTaxModel)
class ProductTaxModel extends HiveObject {
  @HiveField(0)
  final double gstPercent;

  @HiveField(1)
  final TaxTypeModel type;

  @HiveField(2)
  final String? hsnCode;

  ProductTaxModel({
    this.gstPercent = 0,
    this.type = TaxTypeModel.exclusive,
    this.hsnCode,
  });

  ProductTaxModel.exempt({this.hsnCode})
    : gstPercent = 0,
      type = TaxTypeModel.exempt;

  factory ProductTaxModel.fromEntity(ProductTax entity) {
    return ProductTaxModel(
      gstPercent: entity.gstPercent,
      type: TaxTypeModel.values.byName(entity.type.name),
      hsnCode: entity.hsnCode,
    );
  }

  ProductTax toEntity() {
    return ProductTax(
      gstPercent: gstPercent,
      type: TaxType.values.byName(type.name),
      hsnCode: hsnCode,
    );
  }

  factory ProductTaxModel.fromJson(Map<String, dynamic> json) {
    return ProductTaxModel(
      gstPercent: (json['gstPercent'] ?? 0).toDouble(),
      type: TaxTypeModel.values.byName(
        json['type'] ?? TaxTypeModel.exclusive.name,
      ),
      hsnCode: json['hsnCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'gstPercent': gstPercent, 'type': type.name, 'hsnCode': hsnCode};
  }

  ProductTaxModel copyWith({
    double? gstPercent,
    TaxTypeModel? type,
    String? hsnCode,
  }) {
    return ProductTaxModel(
      gstPercent: gstPercent ?? this.gstPercent,
      type: type ?? this.type,
      hsnCode: hsnCode ?? this.hsnCode,
    );
  }
}

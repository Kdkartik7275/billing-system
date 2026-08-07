import 'package:billing_system/features/billing/data/models/bill_item_model.dart';
import 'package:billing_system/features/billing/data/models/coupon_model.dart';
import 'package:billing_system/features/billing/data/models/customer_model.dart';
import 'package:billing_system/features/billing/domain/entities/billing_cart_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'billing_cart_model.g.dart';

@HiveType(typeId: 28)
class BillingCartModel extends HiveObject {
  @HiveField(0)
  final List<BillItemModel> items;

  @HiveField(1)
  final CustomerModel? customer;

  @HiveField(2)
  final CouponModel? coupon;

  BillingCartModel({required this.items, this.customer, this.coupon});

  factory BillingCartModel.fromEntity(BillingCartEntity entity) {
    return BillingCartModel(
      items: entity.items.map((e) => BillItemModel.fromEntity(e)).toList(),
      customer: entity.customer != null
          ? CustomerModel.fromEntity(entity.customer!)
          : null,
      coupon: entity.coupon != null
          ? CouponModel.fromEntity(entity.coupon!)
          : null,
    );
  }

  BillingCartEntity toEntity() {
    return BillingCartEntity(
      items: items.map((e) => e.toEntity()).toList(),
      customer: customer?.toEntity(),
      coupon: coupon?.toEntity(),
    );
  }

  factory BillingCartModel.fromJson(Map<String, dynamic> json) {
    return BillingCartModel(
      items: (json['items'] as List)
          .map((e) => BillItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customer: json['customer'] != null
          ? CustomerModel.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      coupon: json['coupon'] != null
          ? CouponModel.fromJson(json['coupon'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'customer': customer?.toJson(),
      'coupon': coupon?.toJson(),
    };
  }

  BillingCartModel copyWith({
    List<BillItemModel>? items,
    CustomerModel? customer,
    CouponModel? coupon,
  }) {
    return BillingCartModel(
      items: items ?? this.items,
      customer: customer ?? this.customer,
      coupon: coupon ?? this.coupon,
    );
  }
}

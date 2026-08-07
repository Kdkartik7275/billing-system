import 'package:billing_system/features/billing/domain/entities/bill_item_entity.dart';
import 'package:billing_system/features/billing/domain/entities/coupon_entity.dart';
import 'package:billing_system/features/billing/domain/entities/customer_entity.dart';

class BillingCartEntity {
  final List<BillItemEntity> items;

  final CustomerEntity? customer;

  final CouponEntity? coupon;

  const BillingCartEntity({required this.items, this.customer, this.coupon});

  double get subtotal =>
      items.fold(0, (p, e) => p + (e.unitPrice * e.quantity));

  double get totalTax => items.fold(0, (p, e) => p + e.tax);

  double get totalDiscount => items.fold(0, (p, e) => p + e.discount);

  double get grandTotal {
    final total = subtotal + totalTax - totalDiscount;
    return total < 0 ? 0 : total;
  }

  BillingCartEntity copyWith({
    List<BillItemEntity>? items,
    CustomerEntity? customer,
    CouponEntity? coupon,
  }) {
    return BillingCartEntity(
      items: items ?? this.items,
      customer: customer ?? this.customer,
      coupon: coupon ?? this.coupon,
    );
  }
}

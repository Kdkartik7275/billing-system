import 'package:billing_system/core/config/constants/typedefs.dart';
import 'package:billing_system/features/billing/domain/entities/billing_cart_entity.dart';

abstract class BillingCartRepository {
  ResultFuture<BillingCartEntity?> getCart();
  ResultFuture<void> saveCart(BillingCartEntity cart);
  ResultFuture<void> clearCart();
}

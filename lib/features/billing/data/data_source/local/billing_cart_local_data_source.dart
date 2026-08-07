import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract interface class BillingCartLocalDataSource {
  Future<BillingCartModel?> getCart();

  Future<void> saveCart(BillingCartModel cart);

  Future<void> clearCart();
}

class BillingCartLocalDataSourceImpl implements BillingCartLocalDataSource {
  final Box<BillingCartModel> box;

  const BillingCartLocalDataSourceImpl({required this.box});

  static const _cartKey = 'active_cart';

  @override
  Future<BillingCartModel?> getCart() async {
    return box.get(_cartKey);
  }

  @override
  Future<void> saveCart(BillingCartModel cart) async {
    await box.put(_cartKey, cart);
  }

  @override
  Future<void> clearCart() async {
    await box.delete(_cartKey);
  }
}

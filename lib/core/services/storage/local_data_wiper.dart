import 'package:hive/hive.dart';

import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/purchase_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';

class LocalDataWiper {
  static const _deviceScopedKeys = <String>['device_code'];

  static final Map<String, Future<void> Function()> _clearers = {
    'products': () => Hive.box<ProductModel>('products').clear(),
    'categories': () => Hive.box<CategoryModel>('categories').clear(),
    'brands': () => Hive.box<BrandModel>('brands').clear(),
    'units': () => Hive.box<UnitModel>('units').clear(),
    'stocks': () => Hive.box<StockModel>('stocks').clear(),
    'stock_batch': () => Hive.box<StockBatchModel>('stock_batch').clear(),
    'stock_movement': () =>
        Hive.box<StockMovementModel>('stock_movement').clear(),
    'suppliers': () => Hive.box<SupplierModel>('suppliers').clear(),
    'purchases': () => Hive.box<PurchaseModel>('purchases').clear(),
    'current_user': () => Hive.box<UserModel>('current_user').clear(),
    'current_shop': () => Hive.box<ShopModel>('current_shop').clear(),
    'bills': () => Hive.box<BillModel>('bills').clear(),
    'billing_cart': () => Hive.box<BillingCartModel>('billing_cart').clear(),
    // untyped boxes — these were opened with plain Hive.openBox(name),
    // so <dynamic> is correct here and won't throw.
    'settings': () => Hive.box<dynamic>('settings').clear(),
    'billing_meta': _clearBillingMeta,
    'inventory_meta': () => Hive.box<dynamic>('inventory_meta').clear(),
  };

  static Future<void> _clearBillingMeta() async {
    final box = Hive.box<dynamic>('billing_meta');
    final preserved = {
      for (final k in _deviceScopedKeys)
        if (box.containsKey(k)) k: box.get(k),
    };
    await box.clear();
    await box.putAll(preserved);
  }

  static Future<void> wipeAll() async {
    for (final entry in _clearers.entries) {
      if (!Hive.isBoxOpen(entry.key)) continue;
      await entry.value();
    }
  }
}

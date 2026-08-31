import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/data/models/bill_item_model.dart';
import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:billing_system/features/billing/data/models/coupon_model.dart';
import 'package:billing_system/features/billing/data/models/customer_model.dart';
import 'package:billing_system/features/billing/data/models/payment_model.dart';
import 'package:billing_system/features/billing/data/models/payment_summary_model.dart';
import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/data/models/product_image_model.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:billing_system/features/inventory/data/models/product_price_model.dart';
import 'package:billing_system/features/inventory/data/models/product_settings_model.dart';
import 'package:billing_system/features/inventory/data/models/product_tax_model.dart';
import 'package:billing_system/features/inventory/data/models/product_variant_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/purchase_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:billing_system/features/inventory/data/models/tax_type.dart';
import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';
import 'package:billing_system/features/settings/data/models/account_setting_model.dart';
import 'package:billing_system/features/settings/data/models/security_setting_model.dart';
import 'package:billing_system/features/settings/data/models/user_preferences_model.dart';
import 'package:billing_system/features/user/data/models/business_details_model.dart';

import 'package:billing_system/features/user/data/models/firebase_config_model.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Bootstrap {
  static Future<void> initialize() async {
  
    await dotenv.load(fileName: '.env');

    await Hive.initFlutter();

    Hive
      ..registerAdapter(UserModelAdapter())
      ..registerAdapter(UserRoleAdapter())
      ..registerAdapter(FirebaseConfigModelAdapter())
      ..registerAdapter(ShopModelAdapter())
      ..registerAdapter(ProductModelAdapter())
      ..registerAdapter(ProductPriceModelAdapter())
      ..registerAdapter(ProductTaxModelAdapter())
      ..registerAdapter(ProductSettingsModelAdapter())
      ..registerAdapter(ProductVariantModelAdapter())
      ..registerAdapter(VariantAttributeModelAdapter())
      ..registerAdapter(ProductImageModelAdapter())
      ..registerAdapter(TaxTypeModelAdapter())
      ..registerAdapter(CategoryModelAdapter())
      ..registerAdapter(BrandModelAdapter())
      ..registerAdapter(StockModelAdapter())
      ..registerAdapter(StockBatchModelAdapter())
      ..registerAdapter(StockMovementModelAdapter())
      ..registerAdapter(StockMovementTypeModelAdapter())
      // ---------------- BILLING MODULE ----------------
      ..registerAdapter(BillStatusAdapter())
      ..registerAdapter(PaymentMethodAdapter())
      ..registerAdapter(CustomerModelAdapter())
      ..registerAdapter(CouponModelAdapter())
      ..registerAdapter(PaymentModelAdapter())
      ..registerAdapter(PaymentSummaryModelAdapter())
      ..registerAdapter(BillItemModelAdapter())
      ..registerAdapter(BillModelAdapter())
      ..registerAdapter(BillingCartModelAdapter())
      ..registerAdapter(UnitModelAdapter())
      ..registerAdapter(BusinessDetailsModelAdapter())
      ..registerAdapter(AccountSettingsModelAdapter())
      ..registerAdapter(SecuritySettingsModelAdapter())
      ..registerAdapter(UserPreferencesModelAdapter())
      ..registerAdapter(SupplierModelAdapter())
      ..registerAdapter(PurchaseModelAdapter());

    await Hive.openBox<ProductModel>('products');
    await Hive.openBox<CategoryModel>('categories');
    await Hive.openBox<BrandModel>('brands');
    await Hive.openBox<StockModel>('stocks');
    await Hive.openBox<StockMovementModel>('stock_movement');
    await Hive.openBox<StockBatchModel>('stock_batch');

    await Hive.openBox<UserModel>('current_user');
    await Hive.openBox<ShopModel>('current_shop');
    await Hive.openBox<FirebaseConfigModel>('firebase_config');

    // ---------------- BILLING MODULE ----------------
    await Hive.openBox<BillModel>('bills');
    await Hive.openBox<BillingCartModel>('billing_cart');
    await Hive.openBox('billing_meta');
    await Hive.openBox('inventory_meta');
    await Hive.openBox<UnitModel>('units');

    await Hive.openBox('settings');

    // Customer and coupon features are deactivated for MVP.
    // Uncomment when those features are implemented:
    // await Hive.openBox<CustomerModel>('customers');
    // await Hive.openBox<CouponModel>('coupons');

    await DependencyInjection.init();
    Get.put(
      UserController(
        getUserByIdUseCase: sl(),
        getShopByIdUseCase: sl(),
        shopFirebaseService: sl(),
        logoutUsecase: sl(),
        biometricService: sl(),
      ),
      permanent: true,
    );
  }

  static Future<void> recoverFromFailure() async {
    try {
      await Hive.close();
    } catch (_) {
      // ignore — boxes may not have been opened at all
    }

    try {
      // Deletes every box's data from disk (registered adapters aren't required).
      await Hive.deleteFromDisk();
    } catch (e) {}
    await initialize();
  }
}

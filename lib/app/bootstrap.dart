import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/data/models/bill_item_model.dart';
import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:billing_system/features/billing/data/models/coupon_model.dart';
import 'package:billing_system/features/billing/data/models/customer_model.dart';
import 'package:billing_system/features/billing/data/models/held_cart_model.dart';
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

    _registerHiveAdapters();
    await _openHiveBoxes();

    await DependencyInjection.init();
    _initUserController();
  }

  // ---------------- HIVE ADAPTERS ----------------
  static void _registerHiveAdapters() {
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
      ..registerAdapter(UnitModelAdapter())
      ..registerAdapter(BusinessDetailsModelAdapter())
      ..registerAdapter(AccountSettingsModelAdapter())
      ..registerAdapter(SecuritySettingsModelAdapter())
      ..registerAdapter(UserPreferencesModelAdapter())
      ..registerAdapter(SupplierModelAdapter())
      ..registerAdapter(PurchaseModelAdapter());

    _registerBillingAdapters();
  }

  // ---------------- BILLING MODULE ADAPTERS ----------------
  static void _registerBillingAdapters() {
    Hive
      ..registerAdapter(BillStatusAdapter())
      ..registerAdapter(PaymentMethodAdapter())
      ..registerAdapter(CustomerModelAdapter())
      ..registerAdapter(CouponModelAdapter())
      ..registerAdapter(PaymentModelAdapter())
      ..registerAdapter(PaymentSummaryModelAdapter())
      ..registerAdapter(BillItemModelAdapter())
      ..registerAdapter(BillModelAdapter())
      ..registerAdapter(BillingCartModelAdapter())
      ..registerAdapter(HeldCartModelAdapter());
  }

  // ---------------- HIVE BOXES ----------------
  static Future<void> _openHiveBoxes() async {
    await Future.wait([
      Hive.openBox<ProductModel>('products'),
      Hive.openBox<CategoryModel>('categories'),
      Hive.openBox<BrandModel>('brands'),
      Hive.openBox<StockModel>('stocks'),
      Hive.openBox<StockMovementModel>('stock_movement'),
      Hive.openBox<StockBatchModel>('stock_batch'),
      Hive.openBox<UserModel>('current_user'),
      Hive.openBox<ShopModel>('current_shop'),
      Hive.openBox<FirebaseConfigModel>('firebase_config'),
      Hive.openBox<UnitModel>('units'),
      Hive.openBox('settings'),
    ]);

    await _openBillingBoxes();
  }

  // ---------------- BILLING MODULE BOXES ----------------
  static Future<void> _openBillingBoxes() async {
    await Future.wait([
      Hive.openBox<BillModel>('bills'),
      Hive.openBox<BillingCartModel>('billing_cart'),
      Hive.openBox('billing_meta'),
      Hive.openBox('inventory_meta'),
      Hive.openBox<HeldCartModel>('held_carts'),
    ]);
  }

  // ---------------- CONTROLLERS ----------------
  static void _initUserController() {
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
}

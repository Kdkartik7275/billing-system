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
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Bootstrap {
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');

    await Hive.initFlutter();

    _registerHiveAdapters();

    await _handleVersionUpgrade();

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

  // ---------------- VERSION-BASED MIGRATION ----------------
  static Future<void> _handleVersionUpgrade() async {
    final prefs = await SharedPreferences.getInstance();
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version; // e.g. "1.0.3"

    final storedVersion = prefs.getString('hive_schema_version') ?? '0.0.0';

    if (currentVersion != storedVersion) {
      // List of data boxes that can be safely cleared on breaking changes
      final boxesToClear = <String>[
        'products',
        'categories',
        'brands',
        'stocks',
        'stock_movement',
        'stock_batch',
        'bills',
        'billing_cart',
        'held_carts',
        'current_user',
        'current_shop',
        'firebase_config',
        'units',
        'settings',
        'billing_meta',
        'inventory_meta',
      ];

      for (final name in boxesToClear) {
        try {
          if (Hive.isBoxOpen(name)) {
            await Hive.box(name).clear();
          } else if (await Hive.boxExists(name)) {
            final box = await Hive.openBox(name);
            await box.clear();
          }
        } catch (_) {
          // Ignore individual box failures; app will re-sync from server
        }
      }

      await prefs.setString('hive_schema_version', currentVersion);
    }
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

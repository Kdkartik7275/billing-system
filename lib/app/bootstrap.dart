import 'package:billing_system/features/backup/data/model/backup_info_model.dart';
import 'package:billing_system/features/billing/data/models/bill_item_model.dart';
import 'package:billing_system/features/billing/data/models/bill_model.dart';
import 'package:billing_system/features/billing/data/models/billing_cart_model.dart';
import 'package:billing_system/features/billing/data/models/coupon_model.dart';
import 'package:billing_system/features/billing/data/models/customer_model.dart';
import 'package:billing_system/features/billing/data/models/held_cart_model.dart';
import 'package:billing_system/features/billing/data/models/payment_model.dart';
import 'package:billing_system/features/billing/data/models/payment_summary_model.dart';
import 'package:billing_system/core/enums/billing.dart';

import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/data/models/product_image_model.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:billing_system/features/inventory/data/models/product_price_model.dart';
import 'package:billing_system/features/inventory/data/models/product_settings_model.dart';
import 'package:billing_system/features/inventory/data/models/product_tax_model.dart';
import 'package:billing_system/features/inventory/data/models/product_variant_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/purchase_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/purchase_payment_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_batch_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_movement_model.dart';
import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:billing_system/features/inventory/data/models/tax_type.dart';
import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';

import 'package:billing_system/features/reports/data/models/cash_reconciliation_model.dart';
import 'package:billing_system/features/reports/data/models/reports_model.dart';
import 'package:billing_system/features/reports/data/models/sales_summary_model.dart';
import 'package:billing_system/features/reports/data/models/tender_breakdown_model.dart';

import 'package:billing_system/features/settings/data/models/account_setting_model.dart';
import 'package:billing_system/features/settings/data/models/security_setting_model.dart';
import 'package:billing_system/features/settings/data/models/user_preferences_model.dart';

import 'package:billing_system/features/user/data/models/business_details_model.dart';
import 'package:billing_system/features/user/data/models/firebase_config_model.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';

import 'package:billing_system/core/di/init_dependencies.dart';
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

  // ==========================================================
  // HIVE ADAPTERS
  // ==========================================================

  static void _registerHiveAdapters() {
    Hive
      // USER
      ..registerAdapter(UserModelAdapter())
      ..registerAdapter(UserRoleAdapter())
      ..registerAdapter(FirebaseConfigModelAdapter())
      ..registerAdapter(ShopModelAdapter())
      ..registerAdapter(BusinessDetailsModelAdapter())
      ..registerAdapter(AccountSettingsModelAdapter())
      ..registerAdapter(SecuritySettingsModelAdapter())
      ..registerAdapter(UserPreferencesModelAdapter())
      // INVENTORY
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
      ..registerAdapter(SupplierModelAdapter())
      ..registerAdapter(PurchaseModelAdapter())
      ..registerAdapter(PurchasePaymentModelAdapter())
      // BILLING
      ..registerAdapter(BillStatusAdapter())
      ..registerAdapter(PaymentMethodAdapter())
      ..registerAdapter(CustomerModelAdapter())
      ..registerAdapter(CouponModelAdapter())
      ..registerAdapter(PaymentModelAdapter())
      ..registerAdapter(PaymentSummaryModelAdapter())
      ..registerAdapter(BillItemModelAdapter())
      ..registerAdapter(BillModelAdapter())
      ..registerAdapter(BillingCartModelAdapter())
      ..registerAdapter(HeldCartModelAdapter())
      // BACKUP
      ..registerAdapter(BackupInfoModelAdapter())
      // REPORTS
      ..registerAdapter(CashReconciliationModelAdapter())
      ..registerAdapter(TenderBreakdownModelAdapter())
      ..registerAdapter(SalesSummaryModelAdapter())
      ..registerAdapter(ReportModelAdapter());
  }

  // ==========================================================
  // VERSION MIGRATION
  // ==========================================================

  static Future<void> _handleVersionUpgrade() async {
    final prefs = await SharedPreferences.getInstance();

    final packageInfo = await PackageInfo.fromPlatform();

    final currentVersion = packageInfo.version;

    final storedVersion = prefs.getString('hive_schema_version') ?? '0.0.0';

    if (currentVersion == storedVersion) {
      return;
    }

    final boxesToClear = <String>[
      'products',
      'categories',
      'brands',
      'stocks',
      'stock_movement',
      'stock_batch',
      'suppliers',
      'purchases',
      'purchase_payments',
      'current_user',
      'current_shop',
      'firebase_config',
      'units',
      'settings',
      'billing_meta',
      'inventory_meta',
      'bills',
      'billing_cart',
      'held_carts',
      'reports',
    ];

    for (final name in boxesToClear) {
      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box(name).clear();
        } else if (await Hive.boxExists(name)) {
          // IMPORTANT:
          // Do NOT use Hive.openBox(name) here.
          //
          // That opens the box as Box<dynamic> and can cause:
          //
          // Box "units" is already open and of type Box<dynamic>
          //
          // Instead, delete the old box from disk.
          await Hive.deleteBoxFromDisk(name);
        }
      } catch (_) {
        // Ignore individual migration failures.
      }
    }

    await prefs.setString('hive_schema_version', currentVersion);
  }

  // ==========================================================
  // HIVE BOXES
  // ==========================================================

  static Future<void> _openHiveBoxes() async {
    await Future.wait([
      // --------------------------------------------------------
      // USER
      // --------------------------------------------------------
      Hive.openBox<UserModel>('current_user'),

      Hive.openBox<ShopModel>('current_shop'),

      Hive.openBox<FirebaseConfigModel>('firebase_config'),

      // --------------------------------------------------------
      // INVENTORY
      // --------------------------------------------------------
      Hive.openBox<ProductModel>('products'),

      Hive.openBox<CategoryModel>('categories'),

      Hive.openBox<BrandModel>('brands'),

      Hive.openBox<UnitModel>('units'),

      Hive.openBox<StockModel>('stocks'),

      Hive.openBox<StockBatchModel>('stock_batch'),

      Hive.openBox<StockMovementModel>('stock_movement'),

      Hive.openBox<SupplierModel>('suppliers'),

      Hive.openBox<PurchaseModel>('purchases'),

      Hive.openBox<PurchasePaymentModel>('purchase_payments'),

      // --------------------------------------------------------
      // BILLING
      // --------------------------------------------------------
      Hive.openBox<BillModel>('bills'),

      Hive.openBox<BillingCartModel>('billing_cart'),

      Hive.openBox<HeldCartModel>('held_carts'),

      Hive.openBox('billing_meta'),

      Hive.openBox('inventory_meta'),

      // --------------------------------------------------------
      // SETTINGS
      // --------------------------------------------------------
      Hive.openBox('settings'),

      // --------------------------------------------------------
      // BACKUP
      // --------------------------------------------------------
      Hive.openBox<BackupInfoModel>('backup_metadata'),

      // --------------------------------------------------------
      // REPORTS
      // --------------------------------------------------------
      Hive.openBox<ReportModel>('reports'),
    ]);
  }

  // ==========================================================
  // CONTROLLERS
  // ==========================================================

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

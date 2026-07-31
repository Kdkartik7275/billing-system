import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/data/models/brand/brand_model.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/data/models/product_image_model.dart';
import 'package:billing_system/features/inventory/data/models/product_model.dart';
import 'package:billing_system/features/inventory/data/models/product_price_model.dart';
import 'package:billing_system/features/inventory/data/models/product_settings_model.dart';
import 'package:billing_system/features/inventory/data/models/product_tax_model.dart';
import 'package:billing_system/features/inventory/data/models/product_variant_model.dart';
import 'package:billing_system/features/inventory/data/models/stock/stock_model.dart';
import 'package:billing_system/features/inventory/data/models/tax_type.dart';

import 'package:billing_system/features/user/data/models/firebase_config_model.dart';
import 'package:billing_system/features/user/data/models/shop_model.dart';
import 'package:billing_system/features/user/data/models/user_model.dart';
import 'package:billing_system/features/user/domain/entity/user_entity.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:billing_system/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Bootstrap {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
      ..registerAdapter(ProductImageModelAdapter())
      ..registerAdapter(TaxTypeModelAdapter())
      ..registerAdapter(CategoryModelAdapter())
      ..registerAdapter(BrandModelAdapter())
      ..registerAdapter(StockModelAdapter());
    await Hive.openBox<ProductModel>('products');
    await Hive.openBox<CategoryModel>('categories');
    await Hive.openBox<BrandModel>('brands');

    await Hive.openBox<UserModel>('current_user');
    await Hive.openBox<ShopModel>('current_shop');
    await Hive.openBox<FirebaseConfigModel>('firebase_config');
    await DependencyInjection.init();
    Get.put(
      UserController(
        getUserByIdUseCase: sl(),
        getShopByIdUseCase: sl(),
        shopFirebaseService: sl(),
      ),
      permanent: true,
    );
  }
}

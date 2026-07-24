import 'package:billing_system/core/di/init_dependencies.dart';

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

    // Hive.registerAdapter(InventoryProductModelAdapter());
    // Hive.registerAdapter(BillItemModelAdapter());
    // Hive.registerAdapter(BillModelAdapter());
    // Hive.registerAdapter(StockTransactionTypeAdapter());
    // Hive.registerAdapter(StockTransactionModelAdapter());
    // Hive.registerAdapter(StockBatchModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ShopModelAdapter());
    Hive.registerAdapter(UserRoleAdapter());
    Hive.registerAdapter(FirebaseConfigModelAdapter());
    // await Hive.openBox<InventoryProductModel>('products');
    // await Hive.openBox<BillModel>('bills');
    // await Hive.openBox<StockTransactionModel>('stock_transactions');
    // await Hive.openBox<StockBatchModel>('stock_batches');
    await Hive.openBox<UserModel>('current_user');
    await Hive.openBox<ShopModel>('current_shop');
    await Hive.openBox<FirebaseConfigModel>('firebase_config');
    await DependencyInjection.init();
    final userController = Get.put(
      UserController(
        getUserByIdUseCase: sl(),
        getShopByIdUseCase: sl(),
        shopFirebaseService: sl(),
      ),
      permanent: true,
    );

   // await userController.checkSession();
  }
}

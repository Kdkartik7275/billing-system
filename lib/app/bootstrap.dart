import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/data/models/inventory_product.dart';
import 'package:billing_system/features/inventory/data/models/stock_transaction_model.dart';
import 'package:billing_system/features/inventory/domain/entity/stock_transactions_entity.dart';
import 'package:billing_system/features/pos/data/models/bill/bill_item_model.dart';
import 'package:billing_system/features/pos/data/models/bill/bill_model.dart';
import 'package:billing_system/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Bootstrap {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await dotenv.load(fileName: '.env');

    await Hive.initFlutter();

    Hive.registerAdapter(InventoryProductModelAdapter());
    Hive.registerAdapter(BillItemModelAdapter());
    Hive.registerAdapter(BillModelAdapter());
    Hive.registerAdapter(StockTransactionTypeAdapter());
    Hive.registerAdapter(StockTransactionModelAdapter());
    await Hive.openBox<InventoryProductModel>('products');
    await Hive.openBox<BillModel>('bills');
    await Hive.openBox<StockTransactionModel>('stock_transactions');
    DependencyInjection.init();
  }
}

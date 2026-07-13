part of 'init_dependencies.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _initFirebase();
    _initHiveBoxes();
    _initInventory();
    _initPOSBilling();
  }
}

// ----------------------- FIREBASE -----------------------
void _initFirebase() {
  // LazySingleton ensures only one instance is created
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<StorageService>(() => StorageService());

  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(InternetConnection()),
  );
}

// ----------------------- CORE -----------------------
void _initHiveBoxes() async {
  final productsBox = await Hive.openBox<InventoryProductModel>('products');

  sl.registerLazySingleton<Box<InventoryProductModel>>(() => productsBox);
  final billsBox = await Hive.openBox<BillModel>('bills');
  sl.registerLazySingleton<Box<BillModel>>(() => billsBox);
  final stockTransactionBox = await Hive.openBox<StockTransactionModel>(
    'stock_transactions',
  );
  sl.registerLazySingleton<Box<StockTransactionModel>>(
    () => stockTransactionBox,
  );
  final stockBatchesBox = await Hive.openBox<StockBatchModel>('stock_batches');
  sl.registerLazySingleton<Box<StockBatchModel>>(() => stockBatchesBox);
}

// ----------------------- AUTH -----------------------
void _initInventory() {
  // DATASOURCE
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(
      remoteDataSource: sl<InventoryRemoteDataSource>(),
      localDataSource: sl<InventoryLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<InventoryRemoteDataSource>(
    () => InventoryRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<InventoryLocalDataSource>(
    () => InventoryLocalDataSourceImpl(
      box: sl(),
      stockTransactionBox: sl(),
      stockBatchBox: sl(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => AddProductUsecase(sl()));
  sl.registerLazySingleton(() => GetProductsUsecase(sl()));
  sl.registerLazySingleton(() => RefreshProductsUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => SyncProductsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetMovementLogs(repository: sl()));
  sl.registerLazySingleton(() => GetStockBatchesUseCase(repository: sl()));
  sl.registerLazySingleton(() => PurhcaseStockUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductBatchesUsecase(repository: sl()));
}

void _initPOSBilling() {
  // DATASOURCE
  sl.registerLazySingleton<BillingRepository>(
    () => BillRepositoryImpl(
      remoteDataSource: sl<BillRemoteDataSource>(),
      localDataSource: sl<BillLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<BillRemoteDataSource>(
    () => BillRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<BillLocalDataSource>(
    () => BillLocalDataSourceImpl(box: sl()),
  );
  // USECASES
  sl.registerLazySingleton(() => SaveBill(sl()));
  sl.registerLazySingleton(() => GetBillsUsecase(repository: sl()));
  sl.registerLazySingleton(() => SyncPendingBillsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetLastSevenDaysSales(repository: sl()));
  sl.registerLazySingleton(() => GetPendingBillsUseCase(repository: sl()));
}

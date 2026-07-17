part of 'init_dependencies.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _initAuthentication();
    _initUser();
    _initFirebase();
    await _initHiveBoxes();
    _initInventory();
    _initPOSBilling();
  }
}

// ----------------------- FIREBASE -----------------------
void _initFirebase() {
  // LazySingleton ensures only one instance is created
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<ShopFirebaseService>(() => ShopFirebaseService());

  sl.registerLazySingleton<StorageService>(() => StorageService());

  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(InternetConnection()),
  );
}

// ----------------------- CORE -----------------------
Future<void> _initHiveBoxes() async {
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

  final userBox = await Hive.openBox<UserModel>('current_user');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);
  final shopBox = await Hive.openBox<ShopModel>('current_shop');
  sl.registerLazySingleton<Box<ShopModel>>(() => shopBox);
}

// ----------------------- AUTH -----------------------
void _initAuthentication() {
  // DATASOURCE
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDataSource: sl<AuthenticationRemoteDataSource>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
    () =>
        AuthenticationRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // USECASES
  sl.registerLazySingleton(
    () => RequestShopRegistrationUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => LoginUser(repository: sl()));
}

void _initUser() {
  // DATASOURCE
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl<UserRemoteDataSource>(),
      localDataSource: sl<UserLocalDataSource>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(
      userBox: sl(),
      shopBox: sl(),
    ),
  );

  // USECASES
  sl.registerLazySingleton(() => GetUserByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetShopByIdUseCase(repository: sl()));
}

// ----------------------- INVENTORY -----------------------
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
    () => InventoryRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
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
  sl.registerLazySingleton(() => SellStockUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetProductsByids(repository: sl()));
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
    () => BillRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
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

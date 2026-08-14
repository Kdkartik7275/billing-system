part of 'init_dependencies.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _initAuthentication();
    _initUser();
    _initFirebase();
    await _initHiveBoxes();

    _initCategory();
    _initUnit();
    _initStocks();
    _initBrands();
    _initProducts();
    _initBilling();
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
  // ==========================================================
  // Product Module
  // ==========================================================

  final productsBox = await Hive.openBox<ProductModel>('products');
  sl.registerLazySingleton<Box<ProductModel>>(() => productsBox);

  final categoriesBox = await Hive.openBox<CategoryModel>('categories');
  sl.registerLazySingleton<Box<CategoryModel>>(() => categoriesBox);

  final unitBox = await Hive.openBox<UnitModel>('units');
  sl.registerLazySingleton<Box<UnitModel>>(() => unitBox);

  final brandsBox = await Hive.openBox<BrandModel>('brands');
  sl.registerLazySingleton<Box<BrandModel>>(() => brandsBox);

  final stocksBox = await Hive.openBox<StockModel>('stocks');
  sl.registerLazySingleton<Box<StockModel>>(() => stocksBox);

  final stockBatches = await Hive.openBox<StockBatchModel>('stock_batch');
  sl.registerLazySingleton<Box<StockBatchModel>>(() => stockBatches);

  final stockMovements = await Hive.openBox<StockMovementModel>(
    'stock_movement',
  );
  sl.registerLazySingleton<Box<StockMovementModel>>(() => stockMovements);

  // ==========================================================
  // User Module
  // ==========================================================

  final userBox = await Hive.openBox<UserModel>('current_user');
  sl.registerLazySingleton<Box<UserModel>>(() => userBox);

  final shopBox = await Hive.openBox<ShopModel>('current_shop');
  sl.registerLazySingleton<Box<ShopModel>>(() => shopBox);

  final billingMetaBox = await Hive.openBox('billing_meta');
  sl.registerLazySingleton<Box>(() => billingMetaBox);

  final inventoryMetaBox = await Hive.openBox('inventory_meta');
  sl.registerLazySingleton<Box>(
    () => inventoryMetaBox,
    instanceName: 'inventoryMeta',
  );

  // ==========================================================
  // Billing Module
  // ==========================================================

  final billsBox = await Hive.openBox<BillModel>('bills');
  sl.registerLazySingleton<Box<BillModel>>(() => billsBox);

  final billingCartBox = await Hive.openBox<BillingCartModel>('billing_cart');
  sl.registerLazySingleton<Box<BillingCartModel>>(() => billingCartBox);
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
  sl.registerLazySingleton(() => LogoutUsecase(repository: sl()));
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
    () => UserLocalDataSourceImpl(userBox: sl(), shopBox: sl()),
  );

  // USECASES
  sl.registerLazySingleton(() => GetUserByIdUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetShopByIdUseCase(repository: sl()));
}

//----------------------- INVENTORY -----------------------
void _initProducts() {
  // DATASOURCE
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
      localDataSource: sl<ProductLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      box: sl(),
      metaBox: sl<Box>(instanceName: 'inventoryMeta'),
    ),
  );
  // USECASES
  sl.registerLazySingleton(
    () => AddProductUseCase(
      productRepository: sl(),
      stockRepository: sl(),
      getOrCreateBrandUseCase: sl(),
      uploadProductImages: sl(),
      createStockBatchUseCase: sl(),
      createStockMovementUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByBarcodeUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductBySkuUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton(
    () => UpdateProductUseCase(
      getOrCreateBrandUseCase: sl(),
      uploadProductImages: sl(),
      productRepository: sl(),
    ),
  );
  sl.registerLazySingleton(() => UploadProductImages(repository: sl()));
}

void _initCategory() {
  // DATASOURCE
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl<CategoryRemoteDataSource>(),
      localDataSource: sl<CategoryLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
  );
  sl.registerLazySingleton<CategoryLocalDataSource>(
    () => CategoryLocalDataSourceImpl(box: sl()),
  );
  // USECASES
  sl.registerLazySingleton(() => AddCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteCategoryUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateCategoryUsecase(repository: sl()));
}

void _initUnit() {
  // DATASOURCE
  sl.registerLazySingleton<UnitRepository>(
    () => UnitRepositoryImpl(
      remoteDataSource: sl<UnitRemoteDataSource>(),
      localDataSource: sl<UnitLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<UnitRemoteDataSource>(
    () => UnitRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
  );
  sl.registerLazySingleton<UnitLocalDataSource>(
    () => UnitLocalDataSourceImpl(unitBox: sl()),
  );
  // USECASES
  sl.registerLazySingleton(() => AddUnitUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteUnitUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetUnitsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetUnitByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateUnitUsecase(repository: sl()));
}

void _initBrands() {
  // DATASOURCE
  sl.registerLazySingleton<BrandRepository>(
    () => BrandRepositoryImpl(
      remoteDataSource: sl<BrandRemoteDataSource>(),
      localDataSource: sl<BrandLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
  );
  sl.registerLazySingleton<BrandLocalDataSource>(
    () => BrandLocalDataSourceImpl(box: sl()),
  );
  // USECASES
  sl.registerLazySingleton(() => AddBrandUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteBrandUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBrandByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBrandsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetOrCreateBrandUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBrandUsecase(repository: sl()));
}

void _initStocks() {
  // DATASOURCE
  sl.registerLazySingleton<StockRepository>(
    () => StockRepositoryImpl(
      remoteDataSource: sl<StockRemoteDataSource>(),
      localDataSource: sl<StockLocalDataSource>(),
      connectionChecker: sl<ConnectionChecker>(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<StockRemoteDataSource>(
    () => StockRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
  );
  sl.registerLazySingleton<StockLocalDataSource>(
    () => StockLocalDataSourceImpl(
      batchBox: sl(),
      movementBox: sl(),
      stockBox: sl(),
      metaBox: sl<Box>(instanceName: 'inventoryMeta'),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => CreateStockUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductStocksUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetStocksUsecase(repository: sl()));
  sl.registerLazySingleton(() => CreateStockBatchUsecase(repository: sl()));

  sl.registerLazySingleton(() => CreateStockMovementUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetProductStockBatchesUsecase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => GetProductStockMovementsUsecase(repository: sl()),
  );
  sl.registerLazySingleton(() => GetStockBatchesUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetStocksMovementUsecase(repository: sl()));
  sl.registerLazySingleton(() => PurchaseStockUseCase(repository: sl()));
  sl.registerLazySingleton(() => SellStockUsecase(repository: sl()));
  sl.registerLazySingleton(() => AdjustStockUsecase(repository: sl()));
}

void _initBilling() {
  // ---------------- DATA SOURCES ----------------
  sl.registerLazySingleton<BillLocalDataSource>(
    () => BillLocalDataSourceImpl(box: sl<Box<BillModel>>(), metaBox: sl()),
  );
  sl.registerLazySingleton<BillRemoteDataSource>(
    () => BillRemoteDataSourceImpl(
      firestore: sl<ShopFirebaseService>().firestore,
    ),
  );
  sl.registerLazySingleton<BillingCartLocalDataSource>(
    () => BillingCartLocalDataSourceImpl(box: sl<Box<BillingCartModel>>()),
  );

  // ---------------- REPOSITORIES ----------------
  sl.registerLazySingleton<BillRepository>(
    () => BillRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      connectionChecker: sl(),
    ),
  );
  sl.registerLazySingleton<BillingCartRepository>(
    () => BillingCartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<BillSyncScheduler>(
    () => BillSyncScheduler(
      aggregateSoldQuantitiesUsecase: sl(),
      billRepository: sl(),
      metaBox: sl(),
      reduceStockForSoldProductsUsecase: sl(),
    ),
  );

  // ---------------- USE CASES ----------------
  sl.registerLazySingleton(() => CreateBillUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBillByIdUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllBillsUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetBillsByDateRangeUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateBillStatusUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteBillUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetNextBillNumberUsecase(repository: sl()));

  sl.registerLazySingleton(() => GetCartUsecase(repository: sl()));
  sl.registerLazySingleton(() => SaveCartUsecase(repository: sl()));
  sl.registerLazySingleton(() => ClearCartUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetUnsyncedBillsUsecase(repository: sl()));
  sl.registerLazySingleton(() => SyncPendingBillsUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => AggregateSoldQuantitiesUsecase(productRepository: sl()),
  );
  sl.registerLazySingleton(
    () => ReduceStockForSoldProductsUsecase(stockRepository: sl()),
  );
}

part of 'init_dependencies.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _initAuthentication();
    _initUser();
    _initFirebase();
    await _initHiveBoxes();

    _initCategory();
    _initStocks();
    _initBrands();
    _initProducts();
    // _initPOSBilling();
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

  final brandsBox = await Hive.openBox<BrandModel>('brands');
  sl.registerLazySingleton<Box<BrandModel>>(() => brandsBox);

  final stocksBox = await Hive.openBox<StockModel>('stocks');
  sl.registerLazySingleton<Box<StockModel>>(() => stocksBox);

  // ==========================================================
  // User Module
  // ==========================================================

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
    () => ProductLocalDataSourceImpl(box: sl()),
  );
  // USECASES
  sl.registerLazySingleton(
    () => AddProductUseCase(
      productRepository: sl(),
      stockRepository: sl(),
      getOrCreateBrandUseCase: sl(),
      uploadProductImages: sl(),
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
    () => StockLocalDataSourceImpl(box: sl()),
  );
  // USECASES
  sl.registerLazySingleton(() => CreateStockUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetProductStocksUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetStocksUsecase(repository: sl()));
}

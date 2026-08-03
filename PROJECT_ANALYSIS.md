# Billing System — Complete Project Analysis

**Project:** `billing_system` — a Flutter POS + Inventory Management application.

> **Overall assessment:** The codebase is **architecturally mature but functionally mid-refactor**. The Clean Architecture skeleton is real and consistently applied, but large parts of the presentation layer (product detail, dashboard charts, image upload, POS/billing) are commented-out stubs, and there are several concrete runtime bugs verified in source. These are flagged honestly below rather than describing the intended design as if it fully works.

---

## 1. Project Overview

A Flutter-based **Point of Sale (POS) and Inventory Management System** for small retail businesses. Intended features: product management, inventory/stock tracking, billing workflow, dashboard analytics, offline-first data handling, and Firebase synchronization. It is structured as a production-grade, feature-modular application.

Currently, the **Inventory** module is the most complete feature; **Authentication** and **User** are functional; the **Dashboard** is a navigation shell with analytics widgets stubbed out; POS/Billing is not yet implemented.

---

## 2. Architecture Explanation

**Pattern:** Feature-first **Clean Architecture** with three layers per feature (`data` / `domain` / `presentation`).

```
lib/
├── app/            → MyApp (GetMaterialApp), Bootstrap (init sequence)
├── core/           → cross-cutting infrastructure
└── features/
    ├── authentication/   (data/domain/presentation)
    ├── user/             (data/domain/presentation)
    ├── inventory/        (data/domain/presentation)  ← core module
    └── dashboard/        (presentation only — data/ & domain/ are empty)
```

**Layer wiring (dependency rule flows inward):**

```
Presentation (GetX controllers, views, widgets)
      │ calls
      ▼
Domain (UseCases → Repository *interfaces* → Entities / Value Objects)
      ▲ implemented by
      │
Data (Repository impls → Local + Remote datasources → Models)
```

- **Domain** is pure Dart: entities, value objects, abstract repository interfaces, usecases. No Flutter/Firebase imports.
- **Data** implements domain repository interfaces, converting `Model ↔ Entity`. Models carry Hive `@HiveType` adapters and Firestore `toJson/fromJson`.
- **Presentation** never touches repositories directly — controllers call **usecases** resolved from GetIt. (The one exception is `InventoryController.deleteProduct`, which mutates local state without a usecase — see Code Quality.)

**Two DI mechanisms coexist by design:**

- **GetIt** (`sl`) wires datasources → repositories → usecases (the domain/data graph).
- **GetX** (`Get.put`/`Get.lazyPut`) manages controllers and their lifecycle, pulling usecases out of GetIt via `sl()`.

**`core/` contents:** `config/` (routes, theme, responsive, constants), `di/`, `errors/` (`Failure`), `exceptions/` (Firebase/platform/format mappers), `network/` (`ConnectionChecker`), `firebase/` (`ShopFirebaseService`), `services/storage/` (a Cloudinary uploader — _not_ local storage), `usecases/` (base contracts), `snackbars/`, `indicators/`, `helper/`, `extensions/`.

---

## 3. Technology Stack

| Concern           | Choice                                                                | Notes                                                                          |
| ----------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| SDK               | Dart `^3.10.1`, Material 3                                            | `useMaterial3: true`                                                           |
| State management  | **GetX** `^4.7.3`                                                     | `.obs` reactivity, `Obx`, `Get.put/find`, GetX routing                         |
| DI                | **get_it** `^9.2.1`                                                   | `sl` service locator; **everything is `registerLazySingleton`** (no factories) |
| Functional errors | **fpdart** `^1.2.0`                                                   | `Either<Failure,T>` via typedefs                                               |
| Local DB          | **Hive** + `hive_flutter`                                             | typed boxes per feature                                                        |
| Backend           | firebase_core/auth/cloud_firestore                                    | **dual-project** design (see below)                                            |
| Responsive        | **responsive_framework** `^1.5.1`                                     | drives actual breakpoint state                                                 |
| Connectivity      | `internet_connection_checker_plus`                                    | offline-first reads                                                            |
| Charts            | `fl_chart` `^1.2.0`                                                   | dashboard (currently commented out)                                            |
| Scanning          | `mobile_scanner` `^7.2.0`                                             | not yet wired                                                                  |
| Images            | `image_picker` `^1.2.2`                                               | **declared but never imported/used**                                           |
| PDF/print         | `pdf`, `printing`, `qr_flutter`                                       | for future billing/receipts                                                    |
| Config            | `flutter_dotenv`                                                      | `.env` for Cloudinary keys                                                     |
| Misc              | `uuid`, `flutter_spinkit`, `loading_overlay`, `flutter_native_splash` |                                                                                |

**Base contracts** (`core/usecases/usecases.dart`, `core/config/constants/typedefs.dart`):

```dart
typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid      = Future<Either<Failure, void>>;

abstract interface class UseCaseWithParams<Type, Params> {
  ResultFuture<Type> call(Params params);
}
abstract interface class UseCaseWithoutParams<Type> {
  ResultFuture<Type> call();
}
```

`Failure` is abstract with `message` + `statusCode`; the only concrete subtype is `FirebaseFailure` (default `statusCode: 400`).

**Multi-tenant Firebase (important):** There are **two Firebase apps**:

- The **default/root** project holds `users`, `shops`, and `registration_requests`. Auth and User/Shop lookups use `FirebaseFirestore.instance`.
- Each **shop** carries its own full `FirebaseConfigEntity` (API keys, app IDs, projectId). At login, `ShopFirebaseService.initialize(config)` spins up a **named secondary app `'SHOP_APP'`**, and inventory datasources bind to `sl<ShopFirebaseService>().firestore`. So each shop's product/stock data lives in _that shop's own Firebase project_.

---

## 4. Feature Analysis

### Authentication

- **Purpose:** email/password login + shop-registration _requests_.
- **Login flow:** `LoginController.login()` → `LoginUser` usecase → `AuthenticationRepository` → `signInWithEmailAndPassword`. On success it navigates to `FetchingDetailsPage(userId: uid, onDone: → Get.offAllNamed('/dashboard'))`.
- **Registration:** does **not** create an account — `RequestShopRegistrationUseCase` writes a `status: "pending"` doc to `registration_requests`. A human provisions the shop later.
- **Files:** `login_controller.dart` (obs: `isLoading`, `obscurePassword`, `rememberMe`, `errorMessage`), `register_shop_controller.dart` (`isSubmitting`, `submitted`).
- **Notes:** the datasource uses global `FirebaseAuth.instance` rather than the injected one; `rememberMe` is captured but never persisted; there's a hardcoded dev seeder `registerShopOwner()` that writes a real `owner@test.com` account + `SHOP_001` doc with embedded Firebase config.

### User

- **Purpose:** load & cache the logged-in user + their shop, and boot the shop's Firebase app.
- **Entities:** `UserEntity` (uid, shopId, role `{owner,manager,cashier}`, …), `ShopEntity` (+ `plan`, `subscriptionExpiry`, `firebaseConfig`), `FirebaseConfigEntity` (per-platform keys).
- **Flow:** `UserRepositoryImpl` is **cache-first** (Hive → else Firestore → cache). `UserController.checkSession()` is the routing brain: no Firebase user → `/login`; else `restoreSession()` (Hive) or `fetchAccountDetails()` → init `ShopFirebaseService` → `/dashboard`.
- **`fetching_details_page.dart`:** the animated post-login bootstrap screen that runs `fetchAccountDetails` and then calls `onDone`.

### Dashboard

- **Purpose:** the app **shell** (navigation) + intended analytics.
- **Structure:** `DashboardPage` → `AdaptiveLayout` → mobile (Drawer) / tablet (collapsible icon rail) / web (persistent 240px sidebar). `DashboardShellController` holds a single `selectedMenu` enum and routes to the selected page.
- **Reality:** `data/` and `domain/` folders are **empty**. All summary cards show hardcoded `₹0`/`0`; every chart (`sales_line_chart`, `category_pie_chart`, `low_stocks`, `recent_transactions`) and `bill_dashboard_extension.dart` is **100% commented out**, awaiting a `BillsController` that isn't instantiated yet. Only `inventory` is a real reachable page from the shell.

### Inventory — see Section 5.

---

## 5. Inventory Module Analysis

### Product entity / model

`ProductEntity` (immutable, `const`, `copyWith`):

```
id, name, description?, sku, barcode, categoryId, brandId?, unitId,
primarySupplierId?, price: ProductPrice, tax: ProductTax,
settings: ProductSettings, variants: List<ProductVariant>,
images: List<ProductImage>, createdAt, updatedAt?
```

Computed getters: `hasVariants` (`variants.length > 1`), `primaryImageUrl`, `finalSellingPrice => tax.finalPriceFor(price.sellingPrice)`.

`ProductModel` (`@HiveType(typeId: 5)`, `@HiveField(0..15)`) mirrors it exactly and provides `fromEntity/toEntity/fromJson/toJson`, delegating each value object to its own model.

### Pricing (`ProductPrice`)

Fields: `purchasePrice` (the cost), `sellingPrice`, `mrp?`, `wholesalePrice?`. Margins are **derived, not stored**:

- `profitPerUnit = sellingPrice - purchasePrice`
- `marginPercent` = profit / **purchasePrice** × 100 (markup-over-cost, not margin-over-sale)
- `discountOffMrpPercent` = (mrp − selling)/mrp × 100

### Tax (`ProductTax` + `TaxType`)

`enum TaxType { exclusive, inclusive, exempt }`; fields `gstPercent`, `type`, `hsnCode?`.

- `taxAmountFor(price)`: inclusive → back-calculates `price − price/(1+g/100)`; exclusive → `price×g/100`; exempt/0 → 0.
- `finalPriceFor(price)`: exclusive adds tax; inclusive/exempt returns price unchanged.
- **Duplication:** the data layer defines a _separate_ `TaxTypeModel` enum (`@HiveType(typeId: 11)`) bridged to the domain enum by `.byName()`.

### Stock management

- `StockEntity`: `quantity`, `reservedQuantity`, `availableQuantity = quantity − reserved`, `statusFor(threshold)` → `{inStock, lowStock, outOfStock}` (threshold from `ProductSettings.lowStockThreshold`). Persisted as `StockModel` (`typeId 14`).
- `StockBatchEntity` (expiry/batch tracking) and `StockMovementEntity` (signed `quantityChange`, `resultingQuantity`, movement type audit trail) are **richly modeled in the domain but have no data model, datasource, repository, or persistence**. Stock is currently a single mutable aggregate per `(productId, warehouseId)`; `StockRepository` only supports `getAllStock`, `getStockForProduct`, `createInitialStock` — there is **no decrement/update/movement path yet**.

### Local storage & Firebase sync

- **Local (Hive):** each feature has a typed `Box<T>` keyed by entity id (`box.put(id, model)`); search filters `name/sku/barcode` in memory.
- **Remote (Firestore):** flat top-level collections — products in **`prods`**, plus `stocks`, `brands`, `categories`. **No `shops/{shopId}/…` path scoping** — tenant isolation is achieved entirely by pointing at the _shop's separate Firebase project_, not by collection paths.
- **Offline-first policy:**
  - **Reads** = online-preferred with local fallback (`_executeWithOfflineFallback` in the product repo; inlined/duplicated in brand/category/stock repos). Online reads refresh the cache (full clear-and-replace for lists).
  - **Writes** = **online-required, write-through** (`if (!isConnected) return left('No Internet Connection')` → remote first → then cache). No offline write queue / sync — the biggest gap vs the "offline-first" goal.

### Add-product flow

`AddProductUseCase` takes `AddProductParams(product, openingStock)` and orchestrates three collaborators: validates barcode + SKU uniqueness → `GetOrCreateBrandUseCase` (treats `brandId` as a brand _name_) → `productRepository.addProduct` → builds initial `StockEntity` (`warehouseId: 'default'` hardcoded) → `stockRepository.createInitialStock` → returns `(ProductEntity, StockEntity)`.

### Product listing flow

`InventoryController.onInit` runs `loadProducts/Categories/Stocks/Brands` in parallel. `filteredProducts` is a computed getter doing all search/category/brand/supplier/stock-status filtering **client-side**, then sorting. UI reacts via nested `Obx`.

### Product detail flow

**Non-functional today.** `product_detail_page.dart` is entirely commented out, and `InventoryController.selectProduct()` is an empty method — tapping "View" does nothing; "Edit" shows a "coming soon" snackbar.

---

## 6. UI Architecture

- **Screen structure:** every screen is `Page → AdaptiveLayout(mobile:, tablet:, desktop:)`. `AdaptiveLayout` picks a widget by `context.isDesktop/isTablet/isMobile` (extension over `responsive_framework`).
- **Responsive:** breakpoints (MOBILE ≤600 / TABLET 601–1024 / DESKTOP 1025–1920) are set in `app.dart` via `ResponsiveBreakpoints.builder`. `context.isMobile/…` + `context.width/height` are the API screens use. (A separate `AppBreakpoints` int-constants class and a `DeviceType` enum exist but are largely decoupled/unused — a redundancy.)
- **Theme system** (`core/config/theme/`): `AppColors` (static tokens, `primary 0xFF2563EB`…), `AppSpacing` (xs 4 … xxxl 32), `AppRadius` (sm 8 … xl 20), `AppTextTheme` (Inter, full Material `TextTheme`). Consumed via `AppColors.*` and `Theme.of(context).textTheme`.
- **Reusable widgets:** good, theme-compliant ones exist — `EmptyState`, `LoadingWidget`, `DeleteDialog`, `InventoryProductCard`. But many inventory widgets (`InventoryDataTable`, `InventoryFilterBar`, `InventoryHeaderBar`, `InventorySearchBar`, `InventoryStatsPanel`, `StatusChip`) **hardcode colors/radii/text styles** in violation of the theme rules, and there are **two competing product-card implementations** (`InventoryProductCard` is theme-clean but unused; `InventoryDataTable._ProductListCard` is the one actually rendered).

---

## 7. State Management

- **Controllers hold** `.obs` observables and call usecases; widgets react through `Obx`. Example — `InventoryController`: `products`, `categories`, `brands`, `stockRecords`, filter fields (`searchQuery`, `selectedCategoryId`, `selectedStockFilter`), `sortColumn/sortAscending`, `isLoading`, `errorMessage`, plus derived getters (`totalInventoryValue`, `lowStockCount`, …).
- **Loading/error:** each loader flips `isLoading`, folds the `Either`, and shows `AppSnackbar` on failure.
- **UI updates:** `list.assignAll(data)` on an `RxList` triggers `Obx` rebuilds.
- **Weaknesses:** (a) four concurrent loaders share one `isLoading` flag → the first to finish clears it (race); (b) `errorMessage` is set only in `catch`, but `fold` already consumes errors, so the inline error UI is effectively dead; (c) `loadCategories`/`loadBrands` set a copy-pasted `'Failed to load products'` message; (d) redundant nested `Obx` wrapping.

---

## 8. Dependency Injection

- **Setup:** `DependencyInjection.init()` runs feature initializers in order: auth → user → firebase (core singletons) → Hive boxes → category → stocks → brands → products.
- **Everything is `registerLazySingleton`** — no factories, no eager singletons. Ordering is safe only because lazy factories aren't invoked until first `sl()` resolve.
- **Registered graph (per feature):** core (`FirebaseAuth`, root `FirebaseFirestore`, `ShopFirebaseService`, `StorageService`, `ConnectionChecker`) → typed Hive `Box<T>`s → `RemoteDataSource` + `LocalDataSource` → `RepositoryImpl` → usecases. **Controllers are _not_ in GetIt** — they're created by GetX (`Get.put`) and pull usecases via `sl()`.
- **Init flow:** `main()` → `Bootstrap.initialize()` (Firebase → dotenv → `Hive.initFlutter` → register 14 adapters → open boxes → `DependencyInjection.init()` → `Get.put(UserController, permanent: true)`) → `runApp`.

---

## 9. Data Flow

**Open inventory page (read):**

```
InventoryPage.build → Get.put(InventoryController(sl(), sl(), sl(), sl()))
 → onInit → GetProductsUseCase.call()
 → ProductRepositoryImpl.getAllProducts()
     → connected? remote.getAllProducts() (Firestore 'prods') → cache clear+refill
     → offline? local.getAllProducts() (Hive)
 → Either folds → products.assignAll(...)
 → Obx(filteredProducts) rebuilds InventoryDataTable
```

**Add a product (write):**

```
AddProductPage field → TextEditingController listener → draftProduct.copyWith(...)
 → "Add Product" → AddProductController.addProduct()
     → validate name + category, resolve categoryId from name
     → AddProductUseCase(AddProductParams(product, openingStock))
         → check barcode/sku unique → GetOrCreateBrand → productRepo.addProduct (online-only, write-through)
         → build StockEntity(warehouseId:'default', qty:openingStock) → stockRepo.createInitialStock
 → returns (product, stock) → Get.back(result:) → inventory layout inserts into obs lists at index 0
```

---

## 10. Code Quality Observations

**Confirmed runtime bugs (verified in source):**

1. **Hive `typeId` collision — data-corruption / crash risk.** `ProductModel` (`product_model.dart:12`) and `VariantAttributeModel` (`product_variant_model.dart:7`) **both declare `@HiveType(typeId: 5)`**. Registering both adapters throws / corrupts serialization. _Highest-priority fix._
2. **`BrandModel.toJson` is malformed** (`brand_model.dart:47`): `{..., searchName:"searchName"}` — the key is the _field's value_ and the value is the literal string `"searchName"`. Firestore never stores a correct `searchName`, which **breaks the remote `where('searchName', …)` brand lookup**.
3. **"Light" theme declares `Brightness.dark`** (`app_theme.dart:10`) while `themeMode: ThemeMode.light` — inconsistent color scheme; likely unintended.
4. **User/shop cache key mismatch:** `saveUser` writes key `'current_user'` but `getCachedUser(userId)` reads by `uid` → cache-first path always misses and re-hits Firestore (same for shop).
5. **`deleteProduct` doesn't persist:** `InventoryController.deleteProduct` only `removeWhere`s from local lists — never calls `DeleteProductUseCase`. Deletions reappear on reload, and this bypasses the repository (architecture violation).
6. **Parse-throw hazards:** `double.parse(openingStock)` and `int.parse(phone)` with no numeric validation; `StockModel.fromJson` uses non-null-guarded `DateTime.parse(lastUpdated)`.

**Architecture / style issues:**

- Widespread theme-rule violations: hardcoded colors/radii/padding/text styles across inventory widgets; business logic inside `InventoryDataTable`; duplicate card widgets; large commented-out blocks (`product_detail_page`, dashboard charts, `generate_sku`, extensions).
- `image_picker` declared but unused; image upload fully stubbed (`onUpload: () {}`).
- Add-product collects fields (`maxStock`, `minSellingPrice`, `rackLocation`, `internalNotes`, warehouse, images) that are **never persisted**.
- `AddProductController` reaches into `InventoryController` via `Get.find` (tight coupling); `categoryId` stores a category _name_, resolved later by `firstWhere` (throws on mismatch).

**Scalability concerns:**

- **No offline write sync** — writes hard-fail offline, contradicting "offline-first."
- **No stock mutation/movement pipeline** — rich `StockMovement`/`StockBatch` domain exists but sales/adjustments can't yet change stock.
- **Client-side filtering/sorting** of the full product list won't scale to large catalogs (no pagination).
- **Full cache clear-and-refill** on every list read is O(n) churn.
- Suppliers/units/warehouses are hardcoded `const` lists, not repositories.
- `errorMessage`/`isLoading` race conditions in controllers.

---

## 11. Improvements (suggested, prioritized)

1. **Fix the Hive `typeId 5` collision** (assign `VariantAttributeModel` a unique id) — silent data-integrity failure.
2. **Fix `BrandModel.toJson`** to `'searchName': searchName` — restores remote brand lookup.
3. **Correct the `lightTheme` brightness** to `Brightness.light`.
4. **Fix user/shop cache keys** so cache-first actually hits.
5. **Route `deleteProduct` through `DeleteProductUseCase`** and persist.
6. **Add input validation** before `parse` calls; use `tryParse` in `fromJson`.
7. **Build the stock-movement/persistence pipeline** so sales/adjustments mutate stock (wire up `StockMovementEntity`/`StockBatchEntity`).
8. **Add an offline write queue** to deliver true offline-first behavior.
9. **Introduce pagination** and move filtering/sorting server-side for large catalogs.
10. **Theme-compliance cleanup** of inventory widgets; consolidate duplicate product cards; remove dead/commented code.
11. **Back suppliers/units/warehouses** with real repositories instead of hardcoded lists.
12. **Persist all collected add-product fields** or remove the unused inputs.

---

## 12. Development Guidelines

### How to add a new feature

1. `lib/features/<feature>/{data,domain,presentation}`.
2. **Domain first:** entities + value objects (pure Dart) → abstract `repository` interface → usecases implementing `UseCaseWithParams/WithoutParams`, returning `ResultFuture<T>`.
3. **Data:** models (Hive `@HiveType` with a **unique `typeId`** + `fromJson/toJson/fromEntity/toEntity`) → `LocalDataSource` (Hive `Box<T>`) + `RemoteDataSource` (Firestore via `ShopFirebaseService.firestore` for shop data, or root `FirebaseFirestore` for control-plane) → `RepositoryImpl` combining them with `ConnectionChecker` (mirror the offline-first read + write-through pattern).
4. **DI:** add a `_init<Feature>()` in `init_dependencies_main.dart`, register datasources → repo → usecases as `registerLazySingleton`, and call it from `init()`.
5. **Bootstrap:** register any new Hive adapter and open its box in `bootstrap.dart`.
6. **Presentation:** GetX controller (obs + usecases via `sl()`), then views via `AdaptiveLayout`.
7. **Routing:** add a route constant in `app_routes.dart` and a `GetPage` (with a binding) in `app_pages.dart`.

### How to add a new screen

Create `Page` (StatelessWidget) → `Get.put(Controller(...sl()))` → return `AdaptiveLayout(mobile:, tablet:, desktop:)` with three layout widgets. Use `context.isMobile/isTablet/isDesktop`; never fork business logic by size. Wrap reactive regions in `Obx`.

### How to add a new entity / usecase / repository

- **Entity:** pure Dart in `domain/entities` (or `value_objects`), immutable + `copyWith`; add computed getters for business rules.
- **Model:** in `data/models`, unique Hive `typeId`, full mapping methods; register adapter in `bootstrap.dart`.
- **Repository:** interface in `domain/repositories` returning `ResultFuture`; impl in `data/repository_impl` combining local + remote + `ConnectionChecker`.
- **Usecase:** one class per action implementing a `UseCase*` contract; a `Params` class when it needs input.

### Rules to follow while coding here

- **Never hardcode** colors/padding/radius/text styles — use `AppColors/AppSpacing/AppRadius/AppTextTheme`. (Much existing inventory UI violates this; follow `EmptyState`/`DeleteDialog` as the good examples.)
- **No business logic in widgets;** controllers call usecases, widgets never call repositories.
- **Persist through usecases** — don't mutate observable lists as a substitute for a repository call (the `deleteProduct` anti-pattern).
- Every Hive model needs a **unique `typeId`** (audit before adding — 5 is already double-booked).
- Domain layer stays Flutter/Firebase-free.
- Support mobile/tablet/web via `AdaptiveLayout`; reuse widgets; `const` + `final` everywhere; null-safe parsing (`tryParse`, validate before `parse`).
- For a large refactor: analyze → explain approach → list files → wait for confirmation.

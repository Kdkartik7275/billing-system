import 'package:get/get.dart';

import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/stock_batch_entity.dart';
import '../../domain/entities/stock_entity.dart';
import '../../domain/entities/supplier_entity.dart';
import '../../domain/entities/unit_entity.dart';
import '../../domain/entities/warehouse_entity.dart';
import '../../domain/value_objects/product_image.dart';
import '../../domain/value_objects/product_price.dart';
import '../../domain/value_objects/product_settings.dart';
import '../../domain/value_objects/product_tax.dart';

enum StockFilter { all, inStock, lowStock, outOfStock }

class InventoryController extends GetxController {
  // ── Reference data ──────────────────────────────────────────────
  final RxList<CategoryEntity> categories = <CategoryEntity>[].obs;
  final RxList<BrandEntity> brands = <BrandEntity>[].obs;
  final RxList<UnitEntity> units = <UnitEntity>[].obs;
  final RxList<SupplierEntity> suppliers = <SupplierEntity>[].obs;
  final RxList<WarehouseEntity> warehouses = <WarehouseEntity>[].obs;
  final RxList<LocationEntity> locations = <LocationEntity>[].obs;

  // ── Catalog + stock ──────────────────────────────────────────────
  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final RxList<StockEntity> stockRecords = <StockEntity>[].obs;
  final RxList<StockBatchEntity> stockBatches = <StockBatchEntity>[].obs;

  // ── UI state ─────────────────────────────────────────────────────
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = 'All'.obs;
  final RxString selectedBrandId = 'All'.obs;
  final RxString selectedSupplierId = 'All'.obs;
  final Rx<StockFilter> selectedStockFilter = StockFilter.all.obs;

  final RxString sortColumn = 'name'.obs;
  final RxBool sortAscending = true.obs;

  final Rxn<ProductEntity> selectedProduct = Rxn<ProductEntity>();
  final RxBool isLoading = false.obs;

  late final String _defaultWarehouseId;

  @override
  void onInit() {
    super.onInit();
    _seedReferenceData();
    _seedProducts();
    if (products.isNotEmpty) {
      selectedProduct.value = products.first;
    }
  }

  // ────────────────────────────────────────────────────────────────
  // LOOKUPS
  // ────────────────────────────────────────────────────────────────

  String categoryName(String id) =>
      _firstOrNull(categories, (c) => c.id == id)?.name ?? 'Uncategorized';

  String? brandName(String? id) {
    if (id == null) return null;
    return _firstOrNull(brands, (b) => b.id == id)?.name;
  }

  String? supplierName(String? id) {
    if (id == null) return null;
    return _firstOrNull(suppliers, (s) => s.id == id)?.name;
  }

  String unitShortCode(String id) =>
      _firstOrNull(units, (u) => u.id == id)?.shortCode ?? 'pc';

  /// Null-safe "first matching element or null" — written locally instead
  /// of depending on collection package extensions that may or may not be
  /// re-exported by the GetX version in use.
  static T? _firstOrNull<T>(Iterable<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  /// Aggregate on-hand quantity for a product across all warehouses.
  double stockQuantityFor(String productId) {
    return stockRecords
        .where((s) => s.productId == productId)
        .fold<double>(0, (sum, s) => sum + s.quantity);
  }

  /// Derived [StockStatus] for a product, combining its live stock
  /// quantity with its own configured low-stock threshold.
  StockStatus stockStatusFor(ProductEntity product) {
    final qty = stockQuantityFor(product.id);
    if (qty <= 0) return StockStatus.outOfStock;
    if (qty <= product.settings.lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  List<StockBatchEntity> batchesFor(String productId) =>
      stockBatches.where((b) => b.productId == productId).toList();

  // ────────────────────────────────────────────────────────────────
  // COMPUTED — statistics
  // ────────────────────────────────────────────────────────────────

  int get totalProductsCount => products.length;

  double get totalInventoryValue {
    return products.fold<double>(
      0,
      (sum, p) => sum + (p.price.purchasePrice * stockQuantityFor(p.id)),
    );
  }

  int get lowStockCount =>
      products.where((p) => stockStatusFor(p) == StockStatus.lowStock).length;

  int get outOfStockCount =>
      products.where((p) => stockStatusFor(p) == StockStatus.outOfStock).length;

  int get todaysAddedCount {
    final now = DateTime.now();
    return products
        .where(
          (p) =>
              p.createdAt.year == now.year &&
              p.createdAt.month == now.month &&
              p.createdAt.day == now.day,
        )
        .length;
  }

  // ────────────────────────────────────────────────────────────────
  // COMPUTED — filtered + sorted product list
  // ────────────────────────────────────────────────────────────────

  List<ProductEntity> get filteredProducts {
    var list = products.where((p) {
      final matchesSearch =
          searchQuery.value.trim().isEmpty ||
          p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p.sku.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p.barcode.contains(searchQuery.value);

      final matchesCategory =
          selectedCategoryId.value == 'All' ||
          p.categoryId == selectedCategoryId.value;

      final matchesBrand =
          selectedBrandId.value == 'All' || p.brandId == selectedBrandId.value;

      final matchesSupplier =
          selectedSupplierId.value == 'All' ||
          p.primarySupplierId == selectedSupplierId.value;

      final status = stockStatusFor(p);
      final matchesStockFilter = switch (selectedStockFilter.value) {
        StockFilter.all => true,
        StockFilter.inStock => status == StockStatus.inStock,
        StockFilter.lowStock => status == StockStatus.lowStock,
        StockFilter.outOfStock => status == StockStatus.outOfStock,
      };

      return matchesSearch &&
          matchesCategory &&
          matchesBrand &&
          matchesSupplier &&
          matchesStockFilter;
    }).toList();

    list.sort((a, b) {
      int result;
      switch (sortColumn.value) {
        case 'sku':
          result = a.sku.compareTo(b.sku);
          break;
        case 'category':
          result = categoryName(
            a.categoryId,
          ).compareTo(categoryName(b.categoryId));
          break;
        case 'price':
          result = a.price.sellingPrice.compareTo(b.price.sellingPrice);
          break;
        case 'stock':
          result = stockQuantityFor(a.id).compareTo(stockQuantityFor(b.id));
          break;
        case 'supplier':
          result = (supplierName(a.primarySupplierId) ?? '').compareTo(
            supplierName(b.primarySupplierId) ?? '',
          );
          break;
        case 'name':
        default:
          result = a.name.compareTo(b.name);
      }
      return sortAscending.value ? result : -result;
    });

    return list;
  }

  // ────────────────────────────────────────────────────────────────
  // ACTIONS
  // ────────────────────────────────────────────────────────────────

  void updateSearch(String value) => searchQuery.value = value;

  void clearSearch() => searchQuery.value = '';

  void selectCategory(String categoryId) =>
      selectedCategoryId.value = categoryId;

  void selectBrand(String brandId) => selectedBrandId.value = brandId;

  void selectSupplier(String supplierId) =>
      selectedSupplierId.value = supplierId;

  void selectStockFilter(StockFilter filter) =>
      selectedStockFilter.value = filter;

  void setSort(String column) {
    if (sortColumn.value == column) {
      sortAscending.value = !sortAscending.value;
    } else {
      sortColumn.value = column;
      sortAscending.value = true;
    }
  }

  void selectProduct(ProductEntity product) => selectedProduct.value = product;

  Future<void> refreshProducts() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    products.refresh();
    stockRecords.refresh();
    isLoading.value = false;
  }

  void deleteProduct(String productId) {
    products.removeWhere((p) => p.id == productId);
    stockRecords.removeWhere((s) => s.productId == productId);
    stockBatches.removeWhere((b) => b.productId == productId);

    if (selectedProduct.value?.id == productId) {
      selectedProduct.value = products.isNotEmpty ? products.first : null;
    }
  }

  void exportProducts() {
    Get.snackbar(
      'Export started',
      'Preparing ${filteredProducts.length} products for export…',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ────────────────────────────────────────────────────────────────
  // DUMMY DATA SEEDING
  // ────────────────────────────────────────────────────────────────

  void _seedReferenceData() {
    final now = DateTime.now();

    categories.assignAll([
      CategoryEntity(
        id: 'cat_01',
        name: 'Beverages',
        iconName: 'local_drink',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_02',
        name: 'Dairy & Bakery',
        iconName: 'egg',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_03',
        name: 'Snacks & Namkeen',
        iconName: 'fastfood',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_04',
        name: 'Personal Care',
        iconName: 'soap',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_05',
        name: 'Home Care',
        iconName: 'cleaning_services',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_06',
        name: 'Grocery & Staples',
        iconName: 'shopping_basket',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_07',
        name: 'Frozen Foods',
        iconName: 'ac_unit',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_08',
        name: 'Health & Wellness',
        iconName: 'health_and_safety',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_09',
        name: 'Baby Care',
        iconName: 'child_care',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_10',
        name: 'Stationery',
        iconName: 'edit',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_11',
        name: 'Confectionery',
        iconName: 'cake',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_12',
        name: 'Ready to Eat',
        iconName: 'ramen_dining',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_13',
        name: 'Atta, Rice & Dals',
        iconName: 'grain',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_14',
        name: 'Spices & Masala',
        iconName: 'spa',
        createdAt: now,
      ),
      CategoryEntity(
        id: 'cat_15',
        name: 'Tea & Coffee',
        iconName: 'coffee',
        createdAt: now,
      ),
    ]);

    brands.assignAll([
      BrandEntity(
        id: 'brand_01',
        name: 'Amul',
        country: 'India',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_02',
        name: 'Britannia',
        country: 'India',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_03',
        name: 'Nestle',
        country: 'Switzerland',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_04',
        name: 'ITC',
        country: 'India',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_05',
        name: 'Hindustan Unilever',
        country: 'India',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_06',
        name: 'Parle',
        country: 'India',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_07',
        name: 'Coca-Cola',
        country: 'USA',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_08',
        name: 'PepsiCo',
        country: 'USA',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_09',
        name: 'Dabur',
        country: 'India',
        createdAt: now,
      ),
      BrandEntity(
        id: 'brand_10',
        name: 'Colgate-Palmolive',
        country: 'USA',
        createdAt: now,
      ),
    ]);

    units.assignAll([
      UnitEntity(id: 'unit_pc', name: 'Piece', shortCode: 'pc', createdAt: now),
      UnitEntity(
        id: 'unit_kg',
        name: 'Kilogram',
        shortCode: 'kg',
        allowsDecimal: true,
        createdAt: now,
      ),
      UnitEntity(
        id: 'unit_g',
        name: 'Gram',
        shortCode: 'g',
        allowsDecimal: true,
        createdAt: now,
      ),
      UnitEntity(
        id: 'unit_l',
        name: 'Litre',
        shortCode: 'L',
        allowsDecimal: true,
        createdAt: now,
      ),
      UnitEntity(
        id: 'unit_ml',
        name: 'Millilitre',
        shortCode: 'ml',
        createdAt: now,
      ),
      UnitEntity(id: 'unit_box', name: 'Box', shortCode: 'box', createdAt: now),
      UnitEntity(id: 'unit_dz', name: 'Dozen', shortCode: 'dz', createdAt: now),
      UnitEntity(
        id: 'unit_pkt',
        name: 'Packet',
        shortCode: 'pkt',
        createdAt: now,
      ),
    ]);

    suppliers.assignAll([
      SupplierEntity(
        id: 'sup_01',
        name: 'Shree Balaji Distributors',
        contactPerson: 'Rajesh Shah',
        phone: '+91 98200 11223',
        address: 'Andheri East, Mumbai, Maharashtra',
        gstNumber: '27AAACB1234F1Z5',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_02',
        name: 'Radhika Traders',
        contactPerson: 'Sunita Deshmukh',
        phone: '+91 98221 44556',
        address: 'Hadapsar, Pune, Maharashtra',
        gstNumber: '27AACCR5678G1Z2',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_03',
        name: 'Ganesh Wholesale Mart',
        contactPerson: 'Kiran Patel',
        phone: '+91 98790 33445',
        address: 'Maninagar, Ahmedabad, Gujarat',
        gstNumber: '24AABCG4321H1Z8',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_04',
        name: 'Krishna Enterprises',
        contactPerson: 'Vikram Malhotra',
        phone: '+91 98111 22334',
        address: 'Karol Bagh, New Delhi',
        gstNumber: '07AADCK6789J1Z6',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_05',
        name: 'Om Sai Traders',
        contactPerson: 'Manjunath Rao',
        phone: '+91 98450 66778',
        address: 'Jayanagar, Bengaluru, Karnataka',
        gstNumber: '29AABCO9988K1Z1',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_06',
        name: 'Vishal Distributors',
        contactPerson: 'Arun Kumar',
        phone: '+91 98400 55667',
        address: 'T Nagar, Chennai, Tamil Nadu',
        gstNumber: '33AAACV2233L1Z9',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_07',
        name: 'Annapurna Agencies',
        contactPerson: 'Lakshmi Reddy',
        phone: '+91 90000 12121',
        address: 'Ameerpet, Hyderabad, Telangana',
        gstNumber: '36AADCA3344M1Z4',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_08',
        name: 'Jai Bhavani Traders',
        contactPerson: 'Prakash Joshi',
        phone: '+91 98230 77889',
        address: 'Sitabuldi, Nagpur, Maharashtra',
        gstNumber: '27AABCJ5566N1Z7',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_09',
        name: 'Sunrise Wholesale',
        contactPerson: 'Debashish Roy',
        phone: '+91 98300 88990',
        address: 'Gariahat, Kolkata, West Bengal',
        gstNumber: '19AAACS7788P1Z3',
        createdAt: now,
      ),
      SupplierEntity(
        id: 'sup_10',
        name: 'Metro Cash Suppliers',
        contactPerson: 'Farhan Sheikh',
        phone: '+91 98980 99001',
        address: 'Ring Road, Surat, Gujarat',
        gstNumber: '24AADCM8899Q1Z0',
        createdAt: now,
      ),
    ]);

    warehouses.assignAll([
      WarehouseEntity(
        id: 'wh_main',
        name: 'Main Store',
        address: 'Shop No. 4, MG Road, Andheri West, Mumbai',
        isDefault: true,
        createdAt: now,
      ),
      WarehouseEntity(
        id: 'wh_godown',
        name: 'Bhiwandi Godown',
        address: 'Warehouse Complex, Bhiwandi, Thane',
        createdAt: now,
      ),
    ]);
    _defaultWarehouseId = 'wh_main';

    locations.assignAll([
      LocationEntity(
        id: 'loc_01',
        warehouseId: 'wh_main',
        label: 'Front Shelf A1',
        aisle: 'A',
        rack: '1',
        createdAt: now,
      ),
      LocationEntity(
        id: 'loc_02',
        warehouseId: 'wh_main',
        label: 'Cold Storage B2',
        aisle: 'B',
        rack: '2',
        createdAt: now,
      ),
    ]);
  }

  void _seedProducts() {
    final now = DateTime.now();
    final seeds = _productSeeds;

    final newProducts = <ProductEntity>[];
    final newStock = <StockEntity>[];
    final newBatches = <StockBatchEntity>[];

    for (var i = 0; i < seeds.length; i++) {
      final seed = seeds[i];
      final index = i + 1;
      final id = 'prod_${index.toString().padLeft(3, '0')}';
      final sku = 'SKU-${index.toString().padLeft(4, '0')}';
      final barcode =
          '890${(1000000000 + index * 37).toString().substring(0, 10)}';
      final createdAt = now.subtract(Duration(days: seed.daysAgoCreated));

      final product = ProductEntity(
        id: id,
        name: seed.name,
        description:
            '${seed.name} — sourced from ${brands[seed.brandIndex].name}, '
            'stocked at ${warehouses.first.name}.',
        sku: sku,
        barcode: barcode,
        categoryId: categories[seed.categoryIndex].id,
        brandId: brands[seed.brandIndex].id,
        unitId: units[seed.unitIndex].id,
        primarySupplierId: suppliers[seed.supplierIndex].id,
        price: ProductPrice(
          purchasePrice: seed.purchasePrice,
          sellingPrice: seed.sellingPrice,
          mrp: seed.sellingPrice + (seed.sellingPrice * 0.05),
        ),
        tax: ProductTax(gstPercent: seed.gstPercent, hsnCode: seed.hsnCode),
        settings: ProductSettings(lowStockThreshold: seed.lowStockThreshold),
        images: [
          ProductImage(url: seed.imageUrl, isPrimary: true, altText: seed.name),
        ],
        createdAt: createdAt,
      );
      newProducts.add(product);

      newStock.add(
        StockEntity(
          id: 'stock_${index.toString().padLeft(3, '0')}',
          productId: id,
          warehouseId: _defaultWarehouseId,
          quantity: seed.stockQty,
          lastUpdated: now.subtract(Duration(days: seed.daysAgoCreated ~/ 4)),
        ),
      );

      newBatches.add(
        StockBatchEntity(
          id: 'batch_${index.toString().padLeft(3, '0')}',
          productId: id,
          warehouseId: _defaultWarehouseId,
          batchNumber: 'B${now.year}${index.toString().padLeft(4, '0')}',
          quantity: seed.stockQty,
          expiryDate: seed.hasExpiry
              ? now.add(const Duration(days: 120))
              : null,
          purchasePrice: seed.purchasePrice,
          receivedAt: createdAt,
        ),
      );
    }

    products.assignAll(newProducts);
    stockRecords.assignAll(newStock);
    stockBatches.assignAll(newBatches);
  }
}

/// Compact seed record used only to drive [InventoryController._seedProducts].
/// Kept private — the public surface of the controller is the Rx state above.
class _ProductSeed {
  final String name;
  final int categoryIndex;
  final int brandIndex;
  final int unitIndex;
  final int supplierIndex;
  final double purchasePrice;
  final double sellingPrice;
  final double gstPercent;
  final String? hsnCode;
  final double stockQty;
  final int lowStockThreshold;
  final int daysAgoCreated;
  final bool hasExpiry;
  final String imageUrl;

  const _ProductSeed({
    required this.name,
    required this.categoryIndex,
    required this.brandIndex,
    required this.unitIndex,
    required this.supplierIndex,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.gstPercent,
    this.hsnCode,
    required this.stockQty,
    this.lowStockThreshold = 15,
    required this.daysAgoCreated,
    this.hasExpiry = false,
    required this.imageUrl,
  });
}

final List<_ProductSeed> _productSeeds = [
  _ProductSeed(
    name: 'Amul Taaza Toned Milk 1L',
    categoryIndex: 1,
    brandIndex: 0,
    unitIndex: 3,
    supplierIndex: 0,
    purchasePrice: 54,
    sellingPrice: 60,
    gstPercent: 0,
    hsnCode: '0401',
    stockQty: 120,
    daysAgoCreated: 40,
    hasExpiry: true,
    imageUrl: 'https://picsum.photos/seed/amul-milk/200',
  ),
  _ProductSeed(
    name: 'Amul Butter 500g',
    categoryIndex: 1,
    brandIndex: 0,
    unitIndex: 0,
    supplierIndex: 0,
    purchasePrice: 230,
    sellingPrice: 255,
    gstPercent: 5,
    hsnCode: '0405',
    stockQty: 60,
    daysAgoCreated: 35,
    hasExpiry: true,
    imageUrl: 'https://picsum.photos/seed/amul-butter/200',
  ),
  _ProductSeed(
    name: 'Amul Cheese Slices 200g',
    categoryIndex: 1,
    brandIndex: 0,
    unitIndex: 0,
    supplierIndex: 0,
    purchasePrice: 110,
    sellingPrice: 130,
    gstPercent: 12,
    hsnCode: '0406',
    stockQty: 45,
    daysAgoCreated: 20,
    hasExpiry: true,
    imageUrl: 'https://picsum.photos/seed/amul-cheese/200',
  ),
  _ProductSeed(
    name: 'Britannia Good Day Biscuits 200g',
    categoryIndex: 2,
    brandIndex: 1,
    unitIndex: 0,
    supplierIndex: 1,
    purchasePrice: 28,
    sellingPrice: 35,
    gstPercent: 18,
    hsnCode: '1905',
    stockQty: 200,
    daysAgoCreated: 50,
    imageUrl: 'https://picsum.photos/seed/goodday/200',
  ),
  _ProductSeed(
    name: 'Britannia Marie Gold 250g',
    categoryIndex: 2,
    brandIndex: 1,
    unitIndex: 0,
    supplierIndex: 1,
    purchasePrice: 32,
    sellingPrice: 38,
    gstPercent: 18,
    hsnCode: '1905',
    stockQty: 150,
    daysAgoCreated: 50,
    imageUrl: 'https://picsum.photos/seed/mariegold/200',
  ),
  _ProductSeed(
    name: 'Britannia Bread 400g',
    categoryIndex: 1,
    brandIndex: 1,
    unitIndex: 0,
    supplierIndex: 1,
    purchasePrice: 32,
    sellingPrice: 40,
    gstPercent: 5,
    hsnCode: '1905',
    stockQty: 80,
    daysAgoCreated: 0,
    hasExpiry: true,
    imageUrl: 'https://picsum.photos/seed/bread/200',
  ),
  _ProductSeed(
    name: 'Nestle Maggi Noodles 70g',
    categoryIndex: 11,
    brandIndex: 2,
    unitIndex: 0,
    supplierIndex: 2,
    purchasePrice: 12,
    sellingPrice: 14,
    gstPercent: 12,
    hsnCode: '1902',
    stockQty: 300,
    daysAgoCreated: 60,
    imageUrl: 'https://picsum.photos/seed/maggi/200',
  ),
  _ProductSeed(
    name: 'Nestle Milkmaid 400g',
    categoryIndex: 1,
    brandIndex: 2,
    unitIndex: 0,
    supplierIndex: 2,
    purchasePrice: 95,
    sellingPrice: 110,
    gstPercent: 18,
    hsnCode: '0402',
    stockQty: 40,
    daysAgoCreated: 25,
    imageUrl: 'https://picsum.photos/seed/milkmaid/200',
  ),
  _ProductSeed(
    name: 'Nescafe Classic Coffee 50g',
    categoryIndex: 14,
    brandIndex: 2,
    unitIndex: 0,
    supplierIndex: 2,
    purchasePrice: 145,
    sellingPrice: 165,
    gstPercent: 18,
    hsnCode: '2101',
    stockQty: 35,
    daysAgoCreated: 15,
    imageUrl: 'https://picsum.photos/seed/nescafe/200',
  ),
  _ProductSeed(
    name: 'Aashirvaad Atta 5kg',
    categoryIndex: 12,
    brandIndex: 3,
    unitIndex: 1,
    supplierIndex: 3,
    purchasePrice: 210,
    sellingPrice: 240,
    gstPercent: 5,
    hsnCode: '1101',
    stockQty: 70,
    daysAgoCreated: 45,
    imageUrl: 'https://picsum.photos/seed/atta/200',
  ),
  _ProductSeed(
    name: 'Sunfeast Dark Fantasy 300g',
    categoryIndex: 2,
    brandIndex: 3,
    unitIndex: 0,
    supplierIndex: 3,
    purchasePrice: 85,
    sellingPrice: 99,
    gstPercent: 18,
    hsnCode: '1905',
    stockQty: 50,
    daysAgoCreated: 18,
    imageUrl: 'https://picsum.photos/seed/darkfantasy/200',
  ),
  _ProductSeed(
    name: 'Bingo Mad Angles 72g',
    categoryIndex: 2,
    brandIndex: 3,
    unitIndex: 0,
    supplierIndex: 3,
    purchasePrice: 18,
    sellingPrice: 20,
    gstPercent: 12,
    hsnCode: '1905',
    stockQty: 180,
    daysAgoCreated: 10,
    imageUrl: 'https://picsum.photos/seed/bingo/200',
  ),
  _ProductSeed(
    name: 'Surf Excel 1kg',
    categoryIndex: 4,
    brandIndex: 4,
    unitIndex: 1,
    supplierIndex: 4,
    purchasePrice: 150,
    sellingPrice: 175,
    gstPercent: 18,
    hsnCode: '3402',
    stockQty: 65,
    daysAgoCreated: 30,
    imageUrl: 'https://picsum.photos/seed/surfexcel/200',
  ),
  _ProductSeed(
    name: 'Lux Soap 100g',
    categoryIndex: 3,
    brandIndex: 4,
    unitIndex: 0,
    supplierIndex: 4,
    purchasePrice: 28,
    sellingPrice: 34,
    gstPercent: 18,
    hsnCode: '3401',
    stockQty: 220,
    daysAgoCreated: 8,
    imageUrl: 'https://picsum.photos/seed/lux/200',
  ),
  _ProductSeed(
    name: 'Lifebuoy Handwash 200ml',
    categoryIndex: 3,
    brandIndex: 4,
    unitIndex: 4,
    supplierIndex: 4,
    purchasePrice: 65,
    sellingPrice: 78,
    gstPercent: 18,
    hsnCode: '3401',
    stockQty: 55,
    daysAgoCreated: 5,
    imageUrl: 'https://picsum.photos/seed/lifebuoy/200',
  ),
  _ProductSeed(
    name: 'Parle-G Biscuits 100g',
    categoryIndex: 2,
    brandIndex: 5,
    unitIndex: 0,
    supplierIndex: 5,
    purchasePrice: 10,
    sellingPrice: 12,
    gstPercent: 5,
    hsnCode: '1905',
    stockQty: 400,
    daysAgoCreated: 70,
    imageUrl: 'https://picsum.photos/seed/parleg/200',
  ),
  _ProductSeed(
    name: 'Parle Monaco Biscuits 120g',
    categoryIndex: 2,
    brandIndex: 5,
    unitIndex: 0,
    supplierIndex: 5,
    purchasePrice: 20,
    sellingPrice: 24,
    gstPercent: 18,
    hsnCode: '1905',
    stockQty: 160,
    daysAgoCreated: 40,
    imageUrl: 'https://picsum.photos/seed/monaco/200',
  ),
  _ProductSeed(
    name: 'Parle Melody Toffee 100g',
    categoryIndex: 10,
    brandIndex: 5,
    unitIndex: 0,
    supplierIndex: 5,
    purchasePrice: 22,
    sellingPrice: 26,
    gstPercent: 18,
    hsnCode: '1704',
    stockQty: 90,
    daysAgoCreated: 12,
    imageUrl: 'https://picsum.photos/seed/melody/200',
  ),
  _ProductSeed(
    name: 'Coca-Cola 750ml',
    categoryIndex: 0,
    brandIndex: 6,
    unitIndex: 4,
    supplierIndex: 6,
    purchasePrice: 32,
    sellingPrice: 40,
    gstPercent: 28,
    hsnCode: '2202',
    stockQty: 140,
    daysAgoCreated: 6,
    imageUrl: 'https://picsum.photos/seed/cocacola/200',
  ),
  _ProductSeed(
    name: 'Sprite 750ml',
    categoryIndex: 0,
    brandIndex: 6,
    unitIndex: 4,
    supplierIndex: 6,
    purchasePrice: 32,
    sellingPrice: 40,
    gstPercent: 28,
    hsnCode: '2202',
    stockQty: 110,
    daysAgoCreated: 6,
    imageUrl: 'https://picsum.photos/seed/sprite/200',
  ),
  _ProductSeed(
    name: 'Thums Up 750ml',
    categoryIndex: 0,
    brandIndex: 6,
    unitIndex: 4,
    supplierIndex: 6,
    purchasePrice: 32,
    sellingPrice: 40,
    gstPercent: 28,
    hsnCode: '2202',
    stockQty: 95,
    daysAgoCreated: 3,
    imageUrl: 'https://picsum.photos/seed/thumsup/200',
  ),
  _ProductSeed(
    name: "Lay's Classic Salted 52g",
    categoryIndex: 2,
    brandIndex: 7,
    unitIndex: 0,
    supplierIndex: 7,
    purchasePrice: 18,
    sellingPrice: 20,
    gstPercent: 12,
    hsnCode: '2005',
    stockQty: 0,
    daysAgoCreated: 55,
    imageUrl: 'https://picsum.photos/seed/lays/200',
  ),
  _ProductSeed(
    name: 'Pepsi 750ml',
    categoryIndex: 0,
    brandIndex: 7,
    unitIndex: 4,
    supplierIndex: 7,
    purchasePrice: 32,
    sellingPrice: 40,
    gstPercent: 28,
    hsnCode: '2202',
    stockQty: 8,
    daysAgoCreated: 4,
    imageUrl: 'https://picsum.photos/seed/pepsi/200',
  ),
  _ProductSeed(
    name: 'Kurkure Masala Munch 90g',
    categoryIndex: 2,
    brandIndex: 7,
    unitIndex: 0,
    supplierIndex: 7,
    purchasePrice: 18,
    sellingPrice: 20,
    gstPercent: 12,
    hsnCode: '2005',
    stockQty: 130,
    daysAgoCreated: 22,
    imageUrl: 'https://picsum.photos/seed/kurkure/200',
  ),
  _ProductSeed(
    name: 'Dabur Honey 500g',
    categoryIndex: 7,
    brandIndex: 8,
    unitIndex: 0,
    supplierIndex: 8,
    purchasePrice: 160,
    sellingPrice: 190,
    gstPercent: 0,
    hsnCode: '0409',
    stockQty: 30,
    daysAgoCreated: 27,
    imageUrl: 'https://picsum.photos/seed/daburhoney/200',
  ),
  _ProductSeed(
    name: 'Dabur Chyawanprash 500g',
    categoryIndex: 7,
    brandIndex: 8,
    unitIndex: 0,
    supplierIndex: 8,
    purchasePrice: 210,
    sellingPrice: 250,
    gstPercent: 12,
    hsnCode: '3004',
    stockQty: 18,
    daysAgoCreated: 33,
    imageUrl: 'https://picsum.photos/seed/chyawanprash/200',
  ),
  _ProductSeed(
    name: 'Dabur Red Toothpaste 200g',
    categoryIndex: 3,
    brandIndex: 8,
    unitIndex: 0,
    supplierIndex: 8,
    purchasePrice: 75,
    sellingPrice: 90,
    gstPercent: 18,
    hsnCode: '3306',
    stockQty: 0,
    daysAgoCreated: 42,
    imageUrl: 'https://picsum.photos/seed/daburred/200',
  ),
  _ProductSeed(
    name: 'Colgate Strong Teeth 200g',
    categoryIndex: 3,
    brandIndex: 9,
    unitIndex: 0,
    supplierIndex: 9,
    purchasePrice: 78,
    sellingPrice: 92,
    gstPercent: 18,
    hsnCode: '3306',
    stockQty: 7,
    daysAgoCreated: 19,
    imageUrl: 'https://picsum.photos/seed/colgate/200',
  ),
  _ProductSeed(
    name: 'Colgate MaxFresh Mouthwash 250ml',
    categoryIndex: 3,
    brandIndex: 9,
    unitIndex: 4,
    supplierIndex: 9,
    purchasePrice: 98,
    sellingPrice: 115,
    gstPercent: 18,
    hsnCode: '3306',
    stockQty: 42,
    daysAgoCreated: 14,
    imageUrl: 'https://picsum.photos/seed/maxfresh/200',
  ),
  _ProductSeed(
    name: 'Palmolive Naturals Shower Gel 250ml',
    categoryIndex: 3,
    brandIndex: 9,
    unitIndex: 4,
    supplierIndex: 9,
    purchasePrice: 135,
    sellingPrice: 158,
    gstPercent: 18,
    hsnCode: '3401',
    stockQty: 25,
    daysAgoCreated: 0,
    imageUrl: 'https://picsum.photos/seed/palmolive/200',
  ),
];

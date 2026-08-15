import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/features/inventory/domain/entities/category_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/unit_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/category/add_category_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/add_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/unit/add_unit_usecase.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_price.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_settings.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_tax.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

// NOTE: This file assumes `AddCategoryUsecase` and `AddUnitUsecase` are
// registered in your DI container (init_dependencies.dart) the same way
// `AddProductUseCase` already is. Adjust the import paths above to match
// your actual project structure if they differ.
//
// It also assumes `InventoryController` exposes reactive/observable
// `categories` and `units` lists that get updated automatically once a
// category/unit is successfully added through the repository (e.g. via a
// stream subscription or a refresh call inside the use case/repository
// layer). If that's not the case in your app, call whatever refresh method
// your controller provides (e.g. `inventoryController.loadCategories()` /
// `inventoryController.loadUnits()`) right after the add calls below.

class SeedCategoryData {
  final String name;

  const SeedCategoryData({required this.name});
}

class SeedUnitData {
  final String name;
  final String shortName;

  const SeedUnitData({required this.name, required this.shortName});
}

class SeedProductData {
  final String name;
  final String sku;
  final String barcode;
  final String categoryName;
  final String unitName;
  final String? brandName;
  final double purchasePrice;
  final double sellingPrice;
  final double? mrp;
  final double gstPercent;
  final double openingStock;

  const SeedProductData({
    required this.name,
    required this.sku,
    required this.barcode,
    required this.categoryName,
    required this.unitName,
    this.brandName,
    required this.purchasePrice,
    required this.sellingPrice,
    this.mrp,
    required this.gstPercent,
    required this.openingStock,
  });
}

class DummyDataSeeder {
  // ---------------- SAMPLE CATEGORIES ----------------
  static const List<SeedCategoryData> sampleCategories = [
    SeedCategoryData(name: 'Bakery'),
    SeedCategoryData(name: 'Groceries'),
    SeedCategoryData(name: 'Dairy'),
    SeedCategoryData(name: 'Snacks'),
    SeedCategoryData(name: 'Beauty & Cosmetics'),
    SeedCategoryData(name: 'Accessories'),
    SeedCategoryData(name: 'Beverages'),
    SeedCategoryData(name: 'Household'),
    SeedCategoryData(name: 'Stationery'),
  ];

  // ---------------- SAMPLE UNITS ----------------
  static const List<SeedUnitData> sampleUnits = [
    SeedUnitData(name: 'Piece', shortName: 'pc'),
    SeedUnitData(name: 'Bottle', shortName: 'btl'),
    SeedUnitData(name: 'Packet', shortName: 'pkt'),
    SeedUnitData(name: 'Pack', shortName: 'pack'),
    SeedUnitData(name: 'Jar', shortName: 'jar'),
    SeedUnitData(name: 'Bag', shortName: 'bag'),
    SeedUnitData(name: 'Cup', shortName: 'cup'),
  ];

  // ---------------- SAMPLE PRODUCTS ----------------
  // Category/unit names below must match the names seeded above — anything
  // that doesn't resolve gets skipped with a debugPrint, not silently
  // guessed.
  static const List<SeedProductData> sampleProducts = [
    SeedProductData(
      name: 'Parle-G Original Biscuits 200g',
      sku: 'PARLEG-200',
      barcode: '8901234500011',
      categoryName: 'Bakery',
      unitName: 'Piece',
      brandName: 'Parle',
      purchasePrice: 38,
      sellingPrice: 50,
      mrp: 55,
      gstPercent: 5,
      openingStock: 80,
    ),
    SeedProductData(
      name: 'Fortune Sunlite Oil 1L',
      sku: 'FORT-OIL-1L',
      barcode: '8901234500028',
      categoryName: 'Groceries',
      unitName: 'Bottle',
      brandName: 'Fortune',
      purchasePrice: 175,
      sellingPrice: 212,
      mrp: 225,
      gstPercent: 5,
      openingStock: 33,
    ),
    SeedProductData(
      name: 'Amul Taaza Toned Milk 500ml',
      sku: 'AMUL-TAZ-500',
      barcode: '8901234500035',
      categoryName: 'Dairy',
      unitName: 'Packet',
      brandName: 'Amul',
      purchasePrice: 48,
      sellingPrice: 60,
      mrp: 62,
      gstPercent: 0,
      openingStock: 120,
    ),
    SeedProductData(
      name: "Lay's Classic Salted 52g",
      sku: 'LAYS-CLS-52',
      barcode: '8901234500042',
      categoryName: 'Snacks',
      unitName: 'Piece',
      brandName: "Lay's",
      purchasePrice: 15,
      sellingPrice: 20,
      mrp: 20,
      gstPercent: 12,
      openingStock: 60,
    ),
    SeedProductData(
      name: 'Colgate Strong Teeth 150g',
      sku: 'COLG-ST-150',
      barcode: '8901234500059',
      categoryName: 'Beauty & Cosmetics',
      unitName: 'Piece',
      brandName: 'Colgate',
      purchasePrice: 62,
      sellingPrice: 85,
      mrp: 89,
      gstPercent: 18,
      openingStock: 40,
    ),
    SeedProductData(
      name: 'Dettol Original Soap 125g',
      sku: 'DETL-SP-125',
      barcode: '8901234500066',
      categoryName: 'Beauty & Cosmetics',
      unitName: 'Piece',
      brandName: 'Dettol',
      purchasePrice: 28,
      sellingPrice: 40,
      mrp: 42,
      gstPercent: 18,
      openingStock: 55,
    ),
    SeedProductData(
      name: 'Britannia Good Day Cashew 100g',
      sku: 'BRIT-GD-100',
      barcode: '8901234500073',
      categoryName: 'Bakery',
      unitName: 'Piece',
      brandName: 'Britannia',
      purchasePrice: 22,
      sellingPrice: 30,
      mrp: 30,
      gstPercent: 5,
      openingStock: 70,
    ),
    SeedProductData(
      name: 'Maggi 2-Minute Noodles 70g',
      sku: 'MAGGI-2M-70',
      barcode: '8901234500080',
      categoryName: 'Groceries',
      unitName: 'Piece',
      brandName: 'Nestle',
      purchasePrice: 11,
      sellingPrice: 14,
      mrp: 14,
      gstPercent: 12,
      openingStock: 100,
    ),
    SeedProductData(
      name: 'Tata Salt 1kg',
      sku: 'TATA-SALT-1KG',
      barcode: '8901234500097',
      categoryName: 'Groceries',
      unitName: 'Packet',
      brandName: 'Tata',
      purchasePrice: 20,
      sellingPrice: 25,
      mrp: 26,
      gstPercent: 0,
      openingStock: 90,
    ),
    SeedProductData(
      name: 'Cadbury Dairy Milk 40g',
      sku: 'CADB-DM-40',
      barcode: '8901234500103',
      categoryName: 'Snacks',
      unitName: 'Piece',
      brandName: 'Cadbury',
      purchasePrice: 32,
      sellingPrice: 40,
      mrp: 40,
      gstPercent: 18,
      openingStock: 65,
    ),
    SeedProductData(
      name: 'Surf Excel Detergent 1kg',
      sku: 'SURF-EXC-1KG',
      barcode: '8901234500110',
      categoryName: 'Groceries',
      unitName: 'Packet',
      brandName: 'Surf Excel',
      purchasePrice: 105,
      sellingPrice: 135,
      mrp: 140,
      gstPercent: 18,
      openingStock: 25,
    ),
    SeedProductData(
      name: 'Hair Rubber Band Pack',
      sku: 'ACC-HRB-01',
      barcode: '8901234500127',
      categoryName: 'Accessories',
      unitName: 'Pack',
      brandName: null,
      purchasePrice: 8,
      sellingPrice: 15,
      mrp: 15,
      gstPercent: 5,
      openingStock: 200,
    ),
    SeedProductData(
      name: 'Coca-Cola 750ml',
      sku: 'COKE-750',
      barcode: '8901234500134',
      categoryName: 'Beverages',
      unitName: 'Bottle',
      brandName: 'Coca-Cola',
      purchasePrice: 32,
      sellingPrice: 40,
      mrp: 40,
      gstPercent: 28,
      openingStock: 48,
    ),
    SeedProductData(
      name: 'Real Fruit Juice Mixed Fruit 1L',
      sku: 'REAL-MF-1L',
      barcode: '8901234500141',
      categoryName: 'Beverages',
      unitName: 'Bottle',
      brandName: 'Real',
      purchasePrice: 95,
      sellingPrice: 120,
      mrp: 125,
      gstPercent: 12,
      openingStock: 30,
    ),
    SeedProductData(
      name: 'Bisleri Mineral Water 1L',
      sku: 'BISL-WTR-1L',
      barcode: '8901234500158',
      categoryName: 'Beverages',
      unitName: 'Bottle',
      brandName: 'Bisleri',
      purchasePrice: 12,
      sellingPrice: 20,
      mrp: 20,
      gstPercent: 18,
      openingStock: 150,
    ),
    SeedProductData(
      name: 'Nescafe Classic Coffee 50g',
      sku: 'NESC-CLS-50',
      barcode: '8901234500165',
      categoryName: 'Groceries',
      unitName: 'Jar',
      brandName: 'Nescafe',
      purchasePrice: 145,
      sellingPrice: 180,
      mrp: 185,
      gstPercent: 18,
      openingStock: 22,
    ),
    SeedProductData(
      name: 'Red Label Tea 250g',
      sku: 'REDLBL-TEA-250',
      barcode: '8901234500172',
      categoryName: 'Groceries',
      unitName: 'Packet',
      brandName: 'Brooke Bond',
      purchasePrice: 88,
      sellingPrice: 115,
      mrp: 120,
      gstPercent: 5,
      openingStock: 40,
    ),
    SeedProductData(
      name: 'Aashirvaad Atta 5kg',
      sku: 'AASH-ATTA-5KG',
      barcode: '8901234500189',
      categoryName: 'Groceries',
      unitName: 'Bag',
      brandName: 'Aashirvaad',
      purchasePrice: 210,
      sellingPrice: 255,
      mrp: 260,
      gstPercent: 0,
      openingStock: 35,
    ),
    SeedProductData(
      name: 'Fortune Basmati Rice 1kg',
      sku: 'FORT-RICE-1KG',
      barcode: '8901234500196',
      categoryName: 'Groceries',
      unitName: 'Packet',
      brandName: 'Fortune',
      purchasePrice: 95,
      sellingPrice: 120,
      mrp: 125,
      gstPercent: 5,
      openingStock: 45,
    ),
    SeedProductData(
      name: 'Amul Butter 100g',
      sku: 'AMUL-BUTR-100',
      barcode: '8901234500202',
      categoryName: 'Dairy',
      unitName: 'Piece',
      brandName: 'Amul',
      purchasePrice: 48,
      sellingPrice: 58,
      mrp: 60,
      gstPercent: 12,
      openingStock: 50,
    ),
    SeedProductData(
      name: 'Amul Cheese Slices 200g',
      sku: 'AMUL-CHZ-200',
      barcode: '8901234500219',
      categoryName: 'Dairy',
      unitName: 'Packet',
      brandName: 'Amul',
      purchasePrice: 95,
      sellingPrice: 120,
      mrp: 125,
      gstPercent: 12,
      openingStock: 28,
    ),
    SeedProductData(
      name: 'Mother Dairy Curd 400g',
      sku: 'MD-CURD-400',
      barcode: '8901234500226',
      categoryName: 'Dairy',
      unitName: 'Cup',
      brandName: 'Mother Dairy',
      purchasePrice: 28,
      sellingPrice: 35,
      mrp: 36,
      gstPercent: 0,
      openingStock: 60,
    ),
    SeedProductData(
      name: 'Kurkure Masala Munch 90g',
      sku: 'KURK-MM-90',
      barcode: '8901234500233',
      categoryName: 'Snacks',
      unitName: 'Piece',
      brandName: 'Kurkure',
      purchasePrice: 18,
      sellingPrice: 20,
      mrp: 20,
      gstPercent: 12,
      openingStock: 75,
    ),
    SeedProductData(
      name: 'Haldiram Bhujia Sev 200g',
      sku: 'HALD-BHJ-200',
      barcode: '8901234500240',
      categoryName: 'Snacks',
      unitName: 'Packet',
      brandName: 'Haldiram',
      purchasePrice: 42,
      sellingPrice: 55,
      mrp: 58,
      gstPercent: 12,
      openingStock: 38,
    ),
    SeedProductData(
      name: 'Sunfeast Marie Light 250g',
      sku: 'SUNF-ML-250',
      barcode: '8901234500257',
      categoryName: 'Bakery',
      unitName: 'Packet',
      brandName: 'Sunfeast',
      purchasePrice: 40,
      sellingPrice: 50,
      mrp: 52,
      gstPercent: 5,
      openingStock: 44,
    ),
    SeedProductData(
      name: 'Britannia Bread 400g',
      sku: 'BRIT-BRD-400',
      barcode: '8901234500264',
      categoryName: 'Bakery',
      unitName: 'Packet',
      brandName: 'Britannia',
      purchasePrice: 30,
      sellingPrice: 40,
      mrp: 42,
      gstPercent: 0,
      openingStock: 25,
    ),
    SeedProductData(
      name: 'Head & Shoulders Shampoo 180ml',
      sku: 'HNS-SHMP-180',
      barcode: '8901234500271',
      categoryName: 'Beauty & Cosmetics',
      unitName: 'Bottle',
      brandName: 'Head & Shoulders',
      purchasePrice: 135,
      sellingPrice: 175,
      mrp: 180,
      gstPercent: 18,
      openingStock: 20,
    ),
    SeedProductData(
      name: 'Nivea Men Face Wash 100g',
      sku: 'NIVEA-FW-100',
      barcode: '8901234500288',
      categoryName: 'Beauty & Cosmetics',
      unitName: 'Piece',
      brandName: 'Nivea',
      purchasePrice: 98,
      sellingPrice: 125,
      mrp: 130,
      gstPercent: 18,
      openingStock: 30,
    ),
    SeedProductData(
      name: 'Vaseline Petroleum Jelly 100ml',
      sku: 'VASL-PJ-100',
      barcode: '8901234500295',
      categoryName: 'Beauty & Cosmetics',
      unitName: 'Piece',
      brandName: 'Vaseline',
      purchasePrice: 62,
      sellingPrice: 85,
      mrp: 89,
      gstPercent: 18,
      openingStock: 35,
    ),
    SeedProductData(
      name: 'Harpic Toilet Cleaner 500ml',
      sku: 'HARP-TC-500',
      barcode: '8901234500301',
      categoryName: 'Household',
      unitName: 'Bottle',
      brandName: 'Harpic',
      purchasePrice: 65,
      sellingPrice: 85,
      mrp: 89,
      gstPercent: 18,
      openingStock: 32,
    ),
    SeedProductData(
      name: 'Vim Dishwash Bar 200g',
      sku: 'VIM-DB-200',
      barcode: '8901234500318',
      categoryName: 'Household',
      unitName: 'Piece',
      brandName: 'Vim',
      purchasePrice: 15,
      sellingPrice: 20,
      mrp: 20,
      gstPercent: 18,
      openingStock: 90,
    ),
    SeedProductData(
      name: 'Good Knight Mosquito Coil',
      sku: 'GOODK-COIL-01',
      barcode: '8901234500325',
      categoryName: 'Household',
      unitName: 'Pack',
      brandName: 'Good Knight',
      purchasePrice: 22,
      sellingPrice: 30,
      mrp: 32,
      gstPercent: 18,
      openingStock: 55,
    ),
    SeedProductData(
      name: 'Classmate Notebook 200 Pages',
      sku: 'CLSM-NB-200',
      barcode: '8901234500332',
      categoryName: 'Stationery',
      unitName: 'Piece',
      brandName: 'Classmate',
      purchasePrice: 28,
      sellingPrice: 40,
      mrp: 42,
      gstPercent: 12,
      openingStock: 60,
    ),
    SeedProductData(
      name: 'Reynolds Ball Pen Blue',
      sku: 'REYN-PEN-BL',
      barcode: '8901234500349',
      categoryName: 'Stationery',
      unitName: 'Piece',
      brandName: 'Reynolds',
      purchasePrice: 5,
      sellingPrice: 10,
      mrp: 10,
      gstPercent: 12,
      openingStock: 150,
    ),
    SeedProductData(
      name: 'Fevicol Glue 50g',
      sku: 'FEVI-GLU-50',
      barcode: '8901234500356',
      categoryName: 'Stationery',
      unitName: 'Piece',
      brandName: 'Fevicol',
      purchasePrice: 18,
      sellingPrice: 25,
      mrp: 25,
      gstPercent: 18,
      openingStock: 40,
    ),
  ];

  final AddCategoryUsecase _addCategoryUsecase = sl<AddCategoryUsecase>();
  final AddUnitUsecase _addUnitUsecase = sl<AddUnitUsecase>();
  final AddProductUseCase _addProductUseCase = sl<AddProductUseCase>();
  final InventoryController _inventoryController =
      Get.find<InventoryController>();

  /// Runs the full seeding pipeline in order: categories -> units ->
  /// products. Products are seeded last because they depend on category
  /// and unit ids that only exist once the first two steps complete.
  Future<void> seedAll() async {
    await seedCategories();
    await seedUnits();
    await seedSampleProducts();
  }

  // ---------------- CATEGORY SEEDER ----------------
  Future<void> seedCategories() async {
    int success = 0;
    int skipped = 0;

    for (final data in sampleCategories) {
      final alreadyExists = _inventoryController.categories
          .any((c) => c.name == data.name);

      if (alreadyExists) {
        debugPrint('[seed] Category "${data.name}" already exists, skipping.');
        skipped++;
        continue;
      }

      final category = CategoryEntity(
        id: const Uuid().v4(),
        name: data.name,
        createdAt: DateTime.now(),
      );

      final result = await _addCategoryUsecase.call(category);

      result.fold(
        (failure) {
          debugPrint('[seed] Failed category "${data.name}": ${failure.message}');
          skipped++;
        },
        (_) {
          debugPrint('[seed] Added category "${data.name}"');
          success++;
        },
      );
    }

    debugPrint('[seed] Categories done. $success added, $skipped skipped.');
  }

  // ---------------- UNIT SEEDER ----------------
  Future<void> seedUnits() async {
    int success = 0;
    int skipped = 0;

    for (final data in sampleUnits) {
      final alreadyExists =
          _inventoryController.units.any((u) => u.name == data.name);

      if (alreadyExists) {
        debugPrint('[seed] Unit "${data.name}" already exists, skipping.');
        skipped++;
        continue;
      }

      final unit = UnitEntity(
        id: const Uuid().v4(),
        name: data.name,
        shortName: data.shortName,
        createdAt: DateTime.now(),
      );

      final result = await _addUnitUsecase.call(unit);

      result.fold(
        (failure) {
          debugPrint('[seed] Failed unit "${data.name}": ${failure.message}');
          skipped++;
        },
        (_) {
          debugPrint('[seed] Added unit "${data.name}"');
          success++;
        },
      );
    }

    debugPrint('[seed] Units done. $success added, $skipped skipped.');
  }

  // ---------------- PRODUCT SEEDER ----------------
  // Category/unit names in sampleProducts must match names that now exist
  // in InventoryController.categories / .units — anything that doesn't
  // resolve gets skipped with a debugPrint, not silently guessed.
  Future<void> seedSampleProducts() async {
    int success = 0;
    int skipped = 0;

    for (final data in sampleProducts) {
      final category = _inventoryController.categories
          .where((c) => c.name == data.categoryName)
          .firstOrNull;

      final unit = _inventoryController.units
          .where((u) => u.name == data.unitName)
          .firstOrNull;

      if (category == null || unit == null) {
        debugPrint(
          '[seed] Skipping "${data.name}" — '
          '${category == null ? 'category "${data.categoryName}" not found. ' : ''}'
          '${unit == null ? 'unit "${data.unitName}" not found.' : ''}',
        );
        skipped++;
        continue;
      }

      final now = DateTime.now();

      final product = ProductEntity(
        id: const Uuid().v4(),
        name: data.name,
        description: null,
        sku: data.sku,
        barcode: data.barcode,
        categoryId: category.id,
        brandId: data.brandName,
        unitId: unit.id,
        primarySupplierId: null,
        price: ProductPrice(
          purchasePrice: data.purchasePrice,
          sellingPrice: data.sellingPrice,
          mrp: data.mrp,
          wholesalePrice: null,
        ),
        tax: ProductTax(
          gstPercent: data.gstPercent,
          type: TaxType.exclusive,
          hsnCode: null,
        ),
        settings: const ProductSettings(),
        variants: const [],
        images: const [],
        createdAt: now,
        updatedAt: null,
      );

      final result = await _addProductUseCase.call(
        AddProductParams(product: product, openingStock: data.openingStock),
      );

      result.fold(
        (failure) {
          debugPrint('[seed] Failed product "${data.name}": ${failure.message}');
          skipped++;
        },
        (_) {
          debugPrint('[seed] Added product "${data.name}"');
          success++;
        },
      );
    }

    debugPrint('[seed] Products done. $success added, $skipped skipped.');
  }
}

// ---------------- USAGE ----------------
// Somewhere after your DI setup and after InventoryController has been
// registered with Get (e.g. in a debug button, a splash screen dev-only
// hook, or a one-off script):
//
//   await DummyDataSeeder().seedAll();
//
// Or run steps individually if you only need to top up one part:
//
//   final seeder = DummyDataSeeder();
//   await seeder.seedCategories();
//   await seeder.seedUnits();
//   await seeder.seedSampleProducts();
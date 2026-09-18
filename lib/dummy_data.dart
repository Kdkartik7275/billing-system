// ---------------- DUMMY DATA SEEDER: CATEGORIES, SUPPLIERS, UNITS & PRODUCTS ----------------

import 'package:billing_system/core/di/init_dependencies.dart';
import 'package:billing_system/core/exceptions/firebase_exception.dart';
import 'package:billing_system/core/firebase/shop_firebase_service.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/features/inventory/data/models/category/category_model.dart';
import 'package:billing_system/features/inventory/data/models/product_image_model.dart';
import 'package:billing_system/features/inventory/data/models/supplier/supplier_model.dart';
import 'package:billing_system/features/inventory/data/models/unit/unit_model.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/product/add_product_usecase.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_price.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_settings.dart';
import 'package:billing_system/features/inventory/domain/value_objects/product_tax.dart';
import 'package:firebase_core/firebase_core.dart';

class DummyDataSeeder {
  static const _categoriesCollection = 'categories';
  static const _suppliersCollection = 'suppliers';
  static const _unitsCollection = 'units';
  static const _productsCollection = 'products';

  // ---------------- DUMMY CATEGORIES ----------------

  static final List<CategoryModel> dummyCategories = [
    CategoryModel(id: 'cat_01', name: 'Groceries', createdAt: DateTime.now()),
    CategoryModel(id: 'cat_02', name: 'Beverages', createdAt: DateTime.now()),
    CategoryModel(
      id: 'cat_03',
      name: 'Personal Care',
      createdAt: DateTime.now(),
    ),
    CategoryModel(id: 'cat_04', name: 'Household', createdAt: DateTime.now()),
    CategoryModel(id: 'cat_05', name: 'Snacks', createdAt: DateTime.now()),
    CategoryModel(id: 'cat_06', name: 'Dairy', createdAt: DateTime.now()),
    CategoryModel(id: 'cat_07', name: 'Stationery', createdAt: DateTime.now()),
    CategoryModel(id: 'cat_08', name: 'Bakery', createdAt: DateTime.now()),
  ];

  // ---------------- DUMMY SUPPLIERS ----------------

  static final List<SupplierModel> dummySuppliers = [
    SupplierModel(
      id: 'sup_01',
      name: 'Amul Distributors',
      contactPerson: 'Ramesh Gupta',
      phone: '9876543210',
      email: 'ramesh@amuldist.com',
      address: 'Sector 12, Meerut, UP',
      gstNumber: '09ABCDE1234F1Z5',
      createdAt: DateTime.now(),
    ),
    SupplierModel(
      id: 'sup_02',
      name: 'HUL Regional Supply Co.',
      contactPerson: 'Suresh Kumar',
      phone: '9876500001',
      email: 'suresh@hulsupply.com',
      address: 'Industrial Area, Ghaziabad, UP',
      gstNumber: '09FGHIJ5678K1Z2',
      createdAt: DateTime.now(),
    ),
    SupplierModel(
      id: 'sup_03',
      name: 'ITC Foods Wholesale',
      contactPerson: 'Anita Sharma',
      phone: '9876500002',
      email: 'anita@itcwholesale.com',
      address: 'Civil Lines, Meerut, UP',
      gstNumber: '09KLMNO9012P1Z8',
      createdAt: DateTime.now(),
    ),
    SupplierModel(
      id: 'sup_04',
      name: 'Nestlé Direct Traders',
      contactPerson: 'Vikas Yadav',
      phone: '9876500003',
      email: 'vikas@nestledirect.com',
      address: 'Delhi Road, Meerut, UP',
      gstNumber: '09QRSTU3456V1Z4',
      createdAt: DateTime.now(),
    ),
    SupplierModel(
      id: 'sup_05',
      name: 'Local Kirana Supply Chain',
      contactPerson: 'Manoj Tiwari',
      phone: '9876500004',
      email: 'manoj@localkirana.com',
      address: 'Shastri Nagar, Meerut, UP',
      gstNumber: '09WXYZA7890B1Z6',
      createdAt: DateTime.now(),
    ),
  ];

  // ---------------- DUMMY UNITS ----------------

  static final List<UnitModel> dummyUnits = [
    UnitModel(
      id: 'unit_01',
      name: 'Kilogram',
      shortName: 'kg',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_02',
      name: 'Gram',
      shortName: 'g',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_03',
      name: 'Litre',
      shortName: 'L',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_04',
      name: 'Millilitre',
      shortName: 'ml',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_05',
      name: 'Piece',
      shortName: 'pcs',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_06',
      name: 'Pack',
      shortName: 'pack',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_07',
      name: 'Box',
      shortName: 'box',
      createdAt: DateTime.now(),
    ),
    UnitModel(
      id: 'unit_08',
      name: 'Dozen',
      shortName: 'dz',
      createdAt: DateTime.now(),
    ),
  ];

  // ---------------- DUMMY PRODUCTS ----------------

  // categoryId refs: cat_01 Groceries, cat_02 Beverages, cat_03 Personal Care,
  // cat_04 Household, cat_05 Snacks, cat_06 Dairy, cat_07 Stationery, cat_08 Bakery
  //
  // unitId refs: unit_01 kg, unit_02 g, unit_03 L, unit_04 ml, unit_05 pcs,
  // unit_06 pack, unit_07 box, unit_08 dz
  //
  // supplierId refs: sup_01 Amul Distributors, sup_02 HUL Regional Supply,
  // sup_03 ITC Foods Wholesale, sup_04 Nestlé Direct Traders, sup_05 Local Kirana

  static final List<_DummyProductSpec> _dummyProductSpecs = [
    _DummyProductSpec(
      id: 'prod_01',
      name: 'Real Fruit Juice Mixed Fruit 1L',
      brand: 'Real',
      categoryId: 'cat_02',
      unitId: 'unit_03',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=600&h=600&fit=crop',
      purchasePrice: 80,
      sellingPrice: 110,
      gstPercent: 12,
      openingStock: 40,
    ),
    _DummyProductSpec(
      id: 'prod_02',
      name: 'Amul Butter 100g',
      brand: 'Amul',
      categoryId: 'cat_06',
      unitId: 'unit_02',
      supplierId: 'sup_01',
      imageUrl:
          'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=600&h=600&fit=crop',
      purchasePrice: 48,
      sellingPrice: 58,
      gstPercent: 12,
      openingStock: 60,
    ),
    _DummyProductSpec(
      id: 'prod_03',
      name: 'Vaseline Petroleum Jelly 100ml',
      brand: 'Vaseline',
      categoryId: 'cat_03',
      unitId: 'unit_04',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&h=600&fit=crop',
      purchasePrice: 75,
      sellingPrice: 95,
      gstPercent: 18,
      openingStock: 30,
    ),
    _DummyProductSpec(
      id: 'prod_04',
      name: 'Hair Rubber Band Pack',
      brand: 'Generic',
      categoryId: 'cat_03',
      unitId: 'unit_06',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&h=600&fit=crop',
      purchasePrice: 15,
      sellingPrice: 25,
      gstPercent: 5,
      openingStock: 100,
    ),
    _DummyProductSpec(
      id: 'prod_05',
      name: 'Amul Taaza Toned Milk 500ml',
      brand: 'Amul',
      categoryId: 'cat_06',
      unitId: 'unit_04',
      supplierId: 'sup_01',
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&h=600&fit=crop',
      purchasePrice: 24,
      sellingPrice: 28,
      gstPercent: 0,
      openingStock: 80,
    ),
    _DummyProductSpec(
      id: 'prod_06',
      name: 'Dettol Original Soap 125g',
      brand: 'Dettol',
      categoryId: 'cat_03',
      unitId: 'unit_02',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1584305574647-0cc949a2bb9f?w=600&h=600&fit=crop',
      purchasePrice: 30,
      sellingPrice: 40,
      gstPercent: 18,
      openingStock: 70,
    ),
    _DummyProductSpec(
      id: 'prod_07',
      name: 'Good Knight Mosquito Coil',
      brand: 'Good Knight',
      categoryId: 'cat_04',
      unitId: 'unit_06',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1632933265780-31684e484a12?w=600&h=600&fit=crop',
      purchasePrice: 25,
      sellingPrice: 35,
      gstPercent: 18,
      openingStock: 40,
    ),
    _DummyProductSpec(
      id: 'prod_08',
      name: 'Nivea Men Face Wash 100g',
      brand: 'Nivea',
      categoryId: 'cat_03',
      unitId: 'unit_02',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&h=600&fit=crop',
      purchasePrice: 110,
      sellingPrice: 145,
      gstPercent: 18,
      openingStock: 25,
    ),
    _DummyProductSpec(
      id: 'prod_09',
      name: 'Cadbury Dairy Milk 40g',
      brand: 'Cadbury',
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1511381939415-e44015466834?w=600&h=600&fit=crop',
      purchasePrice: 32,
      sellingPrice: 40,
      gstPercent: 18,
      openingStock: 90,
    ),
    _DummyProductSpec(
      id: 'prod_10',
      name: "Lay's Classic Salted 52g",
      brand: "Lay's",
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=600&h=600&fit=crop',
      purchasePrice: 18,
      sellingPrice: 20,
      gstPercent: 12,
      openingStock: 100,
    ),
    _DummyProductSpec(
      id: 'prod_11',
      name: 'Colgate Strong Teeth 150g',
      brand: 'Colgate',
      categoryId: 'cat_03',
      unitId: 'unit_02',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1571775023090-b5a725d6d15e?w=600&h=600&fit=crop',
      purchasePrice: 68,
      sellingPrice: 89,
      gstPercent: 18,
      openingStock: 45,
    ),
    _DummyProductSpec(
      id: 'prod_12',
      name: 'Red Label Tea 250g',
      brand: 'Red Label',
      categoryId: 'cat_02',
      unitId: 'unit_02',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=600&h=600&fit=crop',
      purchasePrice: 110,
      sellingPrice: 135,
      gstPercent: 5,
      openingStock: 35,
    ),
    _DummyProductSpec(
      id: 'prod_13',
      name: 'Fevicol Glue 50g',
      brand: 'Fevicol',
      categoryId: 'cat_04',
      unitId: 'unit_02',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1587145717194-58c2a9c3ee5a?w=600&h=600&fit=crop',
      purchasePrice: 18,
      sellingPrice: 25,
      gstPercent: 18,
      openingStock: 50,
    ),
    _DummyProductSpec(
      id: 'prod_14',
      name: 'Reynolds Ball Pen Blue',
      brand: 'Reynolds',
      categoryId: 'cat_07',
      unitId: 'unit_05',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1585336261022-680e295ce3fe?w=600&h=600&fit=crop',
      purchasePrice: 8,
      sellingPrice: 10,
      gstPercent: 12,
      openingStock: 150,
    ),
    _DummyProductSpec(
      id: 'prod_15',
      name: 'Britannia Bread 400g',
      brand: 'Britannia',
      categoryId: 'cat_08',
      unitId: 'unit_02',
      supplierId: 'sup_03',
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600&h=600&fit=crop',
      purchasePrice: 35,
      sellingPrice: 45,
      gstPercent: 0,
      openingStock: 30,
    ),
    _DummyProductSpec(
      id: 'prod_16',
      name: 'Bisleri Mineral Water 1L',
      brand: 'Bisleri',
      categoryId: 'cat_02',
      unitId: 'unit_03',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1606168094336-48f11702ab29?w=600&h=600&fit=crop',
      purchasePrice: 15,
      sellingPrice: 20,
      gstPercent: 18,
      openingStock: 120,
    ),
    _DummyProductSpec(
      id: 'prod_17',
      name: 'Fortune Basmati Rice 1kg',
      brand: 'Fortune',
      categoryId: 'cat_01',
      unitId: 'unit_01',
      supplierId: 'sup_03',
      imageUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&h=600&fit=crop',
      purchasePrice: 90,
      sellingPrice: 115,
      gstPercent: 5,
      openingStock: 60,
    ),
    _DummyProductSpec(
      id: 'prod_18',
      name: 'Tata Salt 1kg',
      brand: 'Tata',
      categoryId: 'cat_01',
      unitId: 'unit_01',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1518110925495-b0c9c3f5b18b?w=600&h=600&fit=crop',
      purchasePrice: 22,
      sellingPrice: 28,
      gstPercent: 5,
      openingStock: 80,
    ),
    _DummyProductSpec(
      id: 'prod_19',
      name: 'Surf Excel Detergent 1kg',
      brand: 'Surf Excel',
      categoryId: 'cat_04',
      unitId: 'unit_01',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&h=600&fit=crop',
      purchasePrice: 130,
      sellingPrice: 165,
      gstPercent: 18,
      openingStock: 35,
    ),
    _DummyProductSpec(
      id: 'prod_20',
      name: 'Head & Shoulders Shampoo 180ml',
      brand: 'Head & Shoulders',
      categoryId: 'cat_03',
      unitId: 'unit_04',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1585232004423-fdb7c6c8c35b?w=600&h=600&fit=crop',
      purchasePrice: 150,
      sellingPrice: 189,
      gstPercent: 18,
      openingStock: 25,
    ),
    _DummyProductSpec(
      id: 'prod_21',
      name: 'Kurkure Masala Munch 90g',
      brand: 'Kurkure',
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_03',
      imageUrl:
          'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=600&h=600&fit=crop',
      purchasePrice: 18,
      sellingPrice: 20,
      gstPercent: 12,
      openingStock: 100,
    ),
    _DummyProductSpec(
      id: 'prod_22',
      name: 'Harpic Toilet Cleaner 500ml',
      brand: 'Harpic',
      categoryId: 'cat_04',
      unitId: 'unit_04',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1584622781564-1d987f7333c1?w=600&h=600&fit=crop',
      purchasePrice: 65,
      sellingPrice: 85,
      gstPercent: 18,
      openingStock: 30,
    ),
    _DummyProductSpec(
      id: 'prod_23',
      name: 'Classmate Notebook 200 Pages',
      brand: 'Classmate',
      categoryId: 'cat_07',
      unitId: 'unit_05',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1531346878377-a5be20888e57?w=600&h=600&fit=crop',
      purchasePrice: 45,
      sellingPrice: 60,
      gstPercent: 12,
      openingStock: 80,
    ),
    _DummyProductSpec(
      id: 'prod_24',
      name: 'Mother Dairy Curd 400g',
      brand: 'Mother Dairy',
      categoryId: 'cat_06',
      unitId: 'unit_02',
      supplierId: 'sup_01',
      imageUrl:
          'https://images.unsplash.com/photo-1571212515416-fca988083b1c?w=600&h=600&fit=crop',
      purchasePrice: 28,
      sellingPrice: 35,
      gstPercent: 0,
      openingStock: 50,
    ),
    _DummyProductSpec(
      id: 'prod_25',
      name: 'Maggi 2-Minute Noodles 70g',
      brand: 'Maggi',
      categoryId: 'cat_01',
      unitId: 'unit_02',
      supplierId: 'sup_04',
      imageUrl:
          'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?w=600&h=600&fit=crop',
      purchasePrice: 12,
      sellingPrice: 14,
      gstPercent: 12,
      openingStock: 150,
    ),
    _DummyProductSpec(
      id: 'prod_26',
      name: 'Amul Cheese Slices 200g',
      brand: 'Amul',
      categoryId: 'cat_06',
      unitId: 'unit_02',
      supplierId: 'sup_01',
      imageUrl:
          'https://images.unsplash.com/photo-1618164435735-413d3b066c9a?w=600&h=600&fit=crop',
      purchasePrice: 90,
      sellingPrice: 115,
      gstPercent: 12,
      openingStock: 40,
    ),
    _DummyProductSpec(
      id: 'prod_27',
      name: 'Sunfeast Marie Light 250g',
      brand: 'Sunfeast',
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_03',
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600&h=600&fit=crop',
      purchasePrice: 38,
      sellingPrice: 48,
      gstPercent: 18,
      openingStock: 50,
    ),
    _DummyProductSpec(
      id: 'prod_28',
      name: 'Britannia Good Day Cashew 100g',
      brand: 'Britannia',
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_03',
      imageUrl:
          'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?w=600&h=600&fit=crop',
      purchasePrice: 28,
      sellingPrice: 35,
      gstPercent: 18,
      openingStock: 55,
    ),
    _DummyProductSpec(
      id: 'prod_29',
      name: 'Nescafe Classic Coffee 50g',
      brand: 'Nescafe',
      categoryId: 'cat_02',
      unitId: 'unit_02',
      supplierId: 'sup_04',
      imageUrl:
          'https://images.unsplash.com/photo-1447933601403-0c6688de566e?w=600&h=600&fit=crop',
      purchasePrice: 145,
      sellingPrice: 179,
      gstPercent: 5,
      openingStock: 20,
    ),
    _DummyProductSpec(
      id: 'prod_30',
      name: 'Vim Dishwash Bar 200g',
      brand: 'Vim',
      categoryId: 'cat_04',
      unitId: 'unit_02',
      supplierId: 'sup_02',
      imageUrl:
          'https://images.unsplash.com/photo-1585421514738-01798e348b17?w=600&h=600&fit=crop',
      purchasePrice: 15,
      sellingPrice: 20,
      gstPercent: 18,
      openingStock: 90,
    ),
    _DummyProductSpec(
      id: 'prod_31',
      name: 'Haldiram Bhujia Sev 200g',
      brand: 'Haldiram',
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=600&h=600&fit=crop',
      purchasePrice: 42,
      sellingPrice: 55,
      gstPercent: 12,
      openingStock: 45,
    ),
    _DummyProductSpec(
      id: 'prod_32',
      name: 'Fortune Sunlite Oil 1L',
      brand: 'Fortune',
      categoryId: 'cat_01',
      unitId: 'unit_03',
      supplierId: 'sup_03',
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&h=600&fit=crop',
      purchasePrice: 135,
      sellingPrice: 160,
      gstPercent: 5,
      openingStock: 40,
    ),
    _DummyProductSpec(
      id: 'prod_33',
      name: 'Coca-Cola 750ml',
      brand: 'Coca-Cola',
      categoryId: 'cat_02',
      unitId: 'unit_04',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=600&h=600&fit=crop',
      purchasePrice: 30,
      sellingPrice: 40,
      gstPercent: 28,
      openingStock: 100,
    ),
    _DummyProductSpec(
      id: 'prod_34',
      name: 'Parle-G Original Biscuits 200g',
      brand: 'Parle',
      categoryId: 'cat_05',
      unitId: 'unit_02',
      supplierId: 'sup_05',
      imageUrl:
          'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=600&h=600&fit=crop',
      purchasePrice: 18,
      sellingPrice: 22,
      gstPercent: 18,
      openingStock: 120,
    ),
  ];

  // ---------------- UPLOAD CATEGORIES ----------------

  Future<void> uploadDummyCategories() async {
    final firestore = sl<ShopFirebaseService>().firestore;
    print('🟡 uploadDummyCategories: STARTED');

    try {
      for (final category in dummyCategories) {
        await firestore
            .collection(_categoriesCollection)
            .doc(category.id)
            .set(category.toJson());
        print('✅ Category added: ${category.name} (${category.id})');
      }
      print(
        '🟢 uploadDummyCategories: COMPLETED (${dummyCategories.length} categories)',
      );
    } on FirebaseException catch (e, st) {
      print(
        '🔴 uploadDummyCategories: FIREBASE ERROR ${e.code} - ${e.message}',
      );
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.uploadDummyCategories',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      print('🔴 uploadDummyCategories: ERROR $e');
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.uploadDummyCategories',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ---------------- UPLOAD SUPPLIERS ----------------

  Future<void> uploadDummySuppliers() async {
    final firestore = sl<ShopFirebaseService>().firestore;
    print('🟡 uploadDummySuppliers: STARTED');

    try {
      for (final supplier in dummySuppliers) {
        await firestore
            .collection(_suppliersCollection)
            .doc(supplier.id)
            .set(supplier.toJson());
        print('✅ Supplier added: ${supplier.name} (${supplier.id})');
      }
      print(
        '🟢 uploadDummySuppliers: COMPLETED (${dummySuppliers.length} suppliers)',
      );
    } on FirebaseException catch (e, st) {
      print('🔴 uploadDummySuppliers: FIREBASE ERROR ${e.code} - ${e.message}');
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.uploadDummySuppliers',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      print('🔴 uploadDummySuppliers: ERROR $e');
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.uploadDummySuppliers',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ---------------- UPLOAD UNITS ----------------

  Future<void> uploadDummyUnits() async {
    final firestore = sl<ShopFirebaseService>().firestore;
    print('🟡 uploadDummyUnits: STARTED');

    try {
      for (final unit in dummyUnits) {
        await firestore
            .collection(_unitsCollection)
            .doc(unit.id)
            .set(unit.toMap());
        print('✅ Unit added: ${unit.name} (${unit.id})');
      }
      print('🟢 uploadDummyUnits: COMPLETED (${dummyUnits.length} units)');
    } on FirebaseException catch (e, st) {
      print('🔴 uploadDummyUnits: FIREBASE ERROR ${e.code} - ${e.message}');
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.uploadDummyUnits',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      print('🔴 uploadDummyUnits: ERROR $e');
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.uploadDummyUnits',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ---------------- UPLOAD PRODUCTS (via AddProductUseCase) ----------------

  Future<void> uploadDummyProductsViaUseCase() async {
    final addProductUseCase = sl<AddProductUseCase>();

    print('🟡 uploadDummyProductsViaUseCase: STARTED');

    int createdCount = 0;
    int failedCount = 0;

    for (final spec in _dummyProductSpecs) {
      final now = DateTime.now();

      final product = ProductEntity(
        id: spec.id,
        name: spec.name,
        description: null,
        sku: spec.id.toUpperCase(),
        barcode: '890${spec.id.replaceAll('prod_', '').padLeft(9, '0')}',
        categoryId: spec.categoryId,
        brandId: spec.brand, // read as brand NAME by GetOrCreateBrandUseCase
        unitId: spec.unitId,
        primarySupplierId: spec.supplierId,
        price: ProductPrice(
          purchasePrice: spec.purchasePrice,
          sellingPrice: spec.sellingPrice,
          mrp: spec.sellingPrice,
          wholesalePrice: null,
        ),
        tax: ProductTax(
          gstPercent: spec.gstPercent,
          type: TaxType.exclusive,
          hsnCode: null,
        ),
        settings: const ProductSettings(),
        variants: const [],
        images: const [], // skip File-based upload path; backfilled below
        createdAt: now,
        updatedAt: null,
      );

      final result = await addProductUseCase.call(
        AddProductParams(product: product, openingStock: spec.openingStock),
      );

      result.fold(
        (failure) {
          failedCount++;
          print('🔴 Failed: ${spec.name} — ${failure.message}');
        },
        (_) {
          createdCount++;
          print(
            '✅ Created: ${spec.name} (${spec.id}) + opening stock ${spec.openingStock}',
          );
        },
      );
    }

    print('🟢 uploadDummyProductsViaUseCase: COMPLETED');
    print('✅ Created: $createdCount   🔴 Failed: $failedCount');
  }

  // ---------------- BACKFILL PRODUCT IMAGES ----------------

  Future<void> backfillDummyProductImages() async {
    final firestore = sl<ShopFirebaseService>().firestore;

    print('🟡 backfillDummyProductImages: STARTED');

    try {
      int updatedCount = 0;

      for (final spec in _dummyProductSpecs) {
        final image = ProductImageModel(
          url: spec.imageUrl,
          isPrimary: true,
          altText: spec.name,
        );

        await firestore.collection(_productsCollection).doc(spec.id).update({
          'images': [image.toJson()],
        });

        updatedCount++;
        print('✅ Image set: ${spec.name} (${spec.id})');
      }

      print('🟢 backfillDummyProductImages: COMPLETED ($updatedCount updated)');
    } on FirebaseException catch (e, st) {
      print(
        '🔴 backfillDummyProductImages: FIREBASE ERROR ${e.code} - ${e.message}',
      );
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.backfillDummyProductImages',
      );
      throw TFirebaseException(e.code);
    } catch (e, st) {
      print('🔴 backfillDummyProductImages: ERROR $e');
      await CrashlyticsService.recordError(
        e,
        st,
        reason: 'DummyDataSeeder.backfillDummyProductImages',
      );
      throw TFirebaseException('unknown');
    }
  }

  // ---------------- RUN ALL (single entry point) ----------------

  Future<void> seedAllDummyData() async {
    print('🚀 seedAllDummyData: STARTED');

    // Order matters — products reference category/unit/supplier ids.
    await uploadDummyCategories();
    await uploadDummySuppliers();
    await uploadDummyUnits();
    await uploadDummyProductsViaUseCase();
    await backfillDummyProductImages();

    print('🏁 seedAllDummyData: ALL DONE');
  }
}

// ---------------- PRIVATE SPEC MODEL (top-level, outside the class) ----------------

class _DummyProductSpec {
  final String id;
  final String name;
  final String brand;
  final String categoryId;
  final String unitId;
  final String supplierId;
  final String imageUrl;
  final double purchasePrice;
  final double sellingPrice;
  final double gstPercent;
  final double openingStock;

  const _DummyProductSpec({
    required this.id,
    required this.name,
    required this.brand,
    required this.categoryId,
    required this.unitId,
    required this.supplierId,
    required this.imageUrl,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.gstPercent,
    this.openingStock = 50,
  });
}

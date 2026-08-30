import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_purchases_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/supplier/get_suppliers_usecase.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersController extends GetxController {
  final GetSuppliersUsecase getSuppliersUsecase;
  final GetPurchasesUsecase getPurchasesUsecase;

  final RxList<SupplierEntity> suppliers = <SupplierEntity>[].obs;
  final RxList<PurchaseEntity> purchases = <PurchaseEntity>[].obs;
  final RxBool isLoading = false.obs;

  // ---------------- FILTERING ----------------
  final RxString searchQuery = ''.obs;
  final Rx<SupplierTab> selectedTab = SupplierTab.all.obs;

  SuppliersController({
    required this.getSuppliersUsecase,
    required this.getPurchasesUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ---------------------------------------------------------------------------
  // FILTER ACTIONS
  // ---------------------------------------------------------------------------

  void updateSearch(String value) => searchQuery.value = value;

  void selectTab(SupplierTab tab) => selectedTab.value = tab;

  // ---------------------------------------------------------------------------
  // GETTERS
  // ---------------------------------------------------------------------------

  int get totalSuppliers => suppliers.length;

  int get activeSuppliers =>
      suppliers.where((supplier) => supplier.isActive).length;

  double get totalPurchaseAmount =>
      purchases.fold<double>(0, (sum, purchase) => sum + purchase.subtotal);

  double get totalDueAmount => purchases
      .where(
        (purchase) =>
            purchase.paymentMethod == 'Credit (Pay Later)' &&
            purchase.dueAmount > 0,
      )
      .fold<double>(0, (sum, purchase) => sum + purchase.dueAmount);

  int get suppliersWithDueCount {
    final supplierIds = <String>{};
    for (final purchase in purchases) {
      if (purchase.paymentMethod == 'Credit (Pay Later)' &&
          purchase.dueAmount > 0) {
        supplierIds.add(purchase.supplierId);
      }
    }
    return supplierIds.length;
  }

  // ---------------- FILTERED SUPPLIER LIST ----------------

  List<SupplierEntity> get _filteredSuppliers {
    final query = searchQuery.value.trim().toLowerCase();

    return suppliers.where((supplier) {
      final matchesTab = switch (selectedTab.value) {
        SupplierTab.all => true,
        SupplierTab.active => supplier.isActive,
        SupplierTab.inactive => !supplier.isActive,
      };

      final matchesSearch =
          query.isEmpty ||
          supplier.name.toLowerCase().contains(query) ||
          (supplier.phone?.toLowerCase().contains(query) ?? false) ||
          (supplier.address?.toLowerCase().contains(query) ?? false);

      return matchesTab && matchesSearch;
    }).toList();
  }

  List<SupplierListItem> get supplierListItems {
    return _filteredSuppliers.map((supplier) {
      return SupplierListItem(
        initials: _getInitials(supplier.name),
        avatarColor: const Color(0xFF1B8A4C),
        avatarBgColor: const Color(0xFFE5F5EC),
        name: supplier.name,
        phone: supplier.phone ?? 'No phone number',
        location: supplier.address ?? 'No address',
        isActive: supplier.isActive,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // DUE PAYMENTS
  // ---------------------------------------------------------------------------

  List<DuePayment> get duePayments {
    final Map<String, List<PurchaseEntity>> grouped = {};

    for (final purchase in purchases) {
      if (purchase.paymentMethod != 'Credit (Pay Later)') {
        continue;
      }

      if (purchase.dueAmount <= 0) {
        continue;
      }

      grouped.putIfAbsent(purchase.supplierId, () => []).add(purchase);
    }

    final payments = <DuePayment>[];

    for (final entry in grouped.entries) {
      final supplier = _findSupplier(entry.key);

      final supplierPurchases = entry.value;

      final amount = supplierPurchases.fold<double>(
        0,
        (sum, purchase) => sum + purchase.dueAmount,
      );

      final dueDate = supplierPurchases
          .map((purchase) => purchase.dueDate)
          .reduce((a, b) => a.isBefore(b) ? a : b);

      payments.add(
        _createDuePayment(supplier: supplier, amount: amount, dueDate: dueDate),
      );
    }

    // Overdue / earliest due first — sorts directly on each payment's
    // own dueDate now, instead of the previous broken stub.
    payments.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return payments;
  }

  // ---------------------------------------------------------------------------
  // SUPPLIER
  // ---------------------------------------------------------------------------

  SupplierEntity _findSupplier(String supplierId) {
    return suppliers.firstWhere(
      (supplier) => supplier.id == supplierId,
      orElse: () => SupplierEntity(
        id: supplierId,
        name: 'Unknown Supplier',
        isActive: false,
        createdAt: DateTime.now(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CREATE DUE PAYMENT
  // ---------------------------------------------------------------------------

  DuePayment _createDuePayment({
    required SupplierEntity supplier,
    required double amount,
    required DateTime dueDate,
  }) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final difference = due.difference(today).inDays;

    late String statusText;
    late Color statusColor;

    if (difference < 0) {
      statusText = 'Overdue by ${difference.abs()} days';
      statusColor = const Color(0xFFE23744);
    } else if (difference == 0) {
      statusText = 'Due today';
      statusColor = const Color(0xFFE23744);
    } else {
      statusText = 'Due in $difference days';
      statusColor = const Color(0xFFFF9800);
    }

    return DuePayment(
      initials: _getInitials(supplier.name),
      avatarColor: const Color(0xFF1B8A4C),
      avatarBgColor: const Color(0xFFE5F5EC),
      supplierName: supplier.name,
      amount: '₹${amount.toStringAsFixed(2)}',
      statusText: statusText,
      statusColor: statusColor,
      dueDate: dueDate,
    );
  }

  // ---------------------------------------------------------------------------
  // INITIALS
  // ---------------------------------------------------------------------------

  String _getInitials(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return '?';
    }

    final words = trimmedName.split(RegExp(r'\s+'));

    if (words.length >= 2) {
      return '${words.first[0]}${words.last[0]}'.toUpperCase();
    }

    return trimmedName
        .substring(0, trimmedName.length >= 2 ? 2 : 1)
        .toUpperCase();
  }

  // ---------------------------------------------------------------------------
  // LOAD DATA
  // ---------------------------------------------------------------------------

  Future<void> loadData() async {
    try {
      isLoading.value = true;

      await Future.wait([loadSuppliers(), loadPurchases()]);
    } catch (e, stackTrace) {
      debugPrint('[SuppliersController] loadData error: $e');
      debugPrint('$stackTrace');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadSuppliers() async {
    try {
      final result = await getSuppliersUsecase.call();

      result.fold(
        (failure) {
          AppSnackbar.error(
            message: failure.message.isNotEmpty
                ? failure.message
                : 'Failed to load suppliers.',
          );
        },
        (data) {
          suppliers.assignAll(data);

          debugPrint('[SuppliersController] Suppliers loaded: ${data.length}');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[SuppliersController] loadSuppliers error: $e');
      debugPrint('$stackTrace');

      AppSnackbar.error(
        message: 'Something went wrong while loading suppliers.',
      );
    }
  }

  Future<void> loadPurchases() async {
    try {
      final result = await getPurchasesUsecase.call();

      result.fold(
        (failure) {
          AppSnackbar.error(
            message: failure.message.isNotEmpty
                ? failure.message
                : 'Failed to load purchases.',
          );
        },
        (data) {
          purchases.assignAll(data);

          debugPrint('[SuppliersController] Purchases loaded: ${data.length}');
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[SuppliersController] loadPurchases error: $e');
      debugPrint('$stackTrace');

      AppSnackbar.error(
        message: 'Something went wrong while loading purchases.',
      );
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }
}

class SupplierListItem {
  final String initials;
  final Color avatarColor;
  final Color avatarBgColor;
  final String name;
  final String phone;
  final String location;
  final bool isActive;

  const SupplierListItem({
    required this.initials,
    required this.avatarColor,
    required this.avatarBgColor,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
  });
}

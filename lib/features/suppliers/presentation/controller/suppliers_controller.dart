import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/services/crash/crashlytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/purchase_payment_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/supplier_entity.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_purchase_payments_by_supplier.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_purchases_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/get_supplier_purchases_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/stock/make_purchase_payment_usecase.dart';
import 'package:billing_system/features/inventory/domain/usecases/supplier/get_suppliers_usecase.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/due_payment_card.dart';
import 'package:billing_system/features/suppliers/presentation/widgets/supplier_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuppliersController extends GetxController {
  final GetSuppliersUsecase getSuppliersUsecase;
  final GetPurchasesUsecase getPurchasesUsecase;
  final MakePurchasePaymentUseCase makePurchasePaymentUsecase;
  final GetSupplierPurchasesUsecase getSupplierPurchasesUsecase;
  final GetPurchasePaymentsBySupplierUsecase
  getPurchasePaymentsBySupplierUsecase;

  final RxList<SupplierEntity> suppliers = <SupplierEntity>[].obs;
  final RxList<PurchaseEntity> purchases = <PurchaseEntity>[].obs;
  final RxList<PurchaseEntity> supplierPurchases = <PurchaseEntity>[].obs;
  final RxList<PurchasePaymentEntity> supplierPayments =
      <PurchasePaymentEntity>[].obs;
  final RxBool isLoadingPayments = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingSupplierPurchases = false.obs;

  // ---------------- FILTERING ----------------
  final RxString searchQuery = ''.obs;
  final Rx<SupplierTab> selectedTab = SupplierTab.all.obs;

  SuppliersController({
    required this.getSuppliersUsecase,
    required this.getPurchasesUsecase,
    required this.makePurchasePaymentUsecase,
    required this.getPurchasePaymentsBySupplierUsecase,
    required this.getSupplierPurchasesUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('Suppliers');
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
      .where((purchase) => purchase.dueAmount > 0)
      .fold<double>(0, (sum, purchase) => sum + purchase.dueAmount);

  int get suppliersWithDueCount {
    final supplierIds = <String>{};
    for (final purchase in purchases) {
      if (purchase.dueAmount > 0) {
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
        supplierId: supplier.id
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // DUE PAYMENTS
  // ---------------------------------------------------------------------------

  List<DuePayment> get duePayments {
    final Map<String, List<PurchaseEntity>> grouped = {};

    for (final purchase in purchases) {
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
      supplierId: supplier.id,
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

      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'SuppliersController.loadData',
        fatal: false,
      );
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

      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'SuppliersController.loadSuppliers',
        fatal: false,
      );

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

      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'SuppliersController.loadPurchases',
        fatal: false,
      );

      AppSnackbar.error(
        message: 'Something went wrong while loading purchases.',
      );
    }
  }

  Future<void> loadPurchasesForSupplier(String supplierId) async {
    try {
      isLoadingSupplierPurchases.value = true;
      supplierPurchases.clear();

      final result = await getSupplierPurchasesUsecase.call(supplierId);

      result.fold(
        (failure) {
          debugPrint(
            '[SuppliersController] loadPurchasesForSupplier failure: ${failure.message}',
          );
        },
        (data) {
          final sorted = [...data]
            ..sort((a, b) => b.dueDate.compareTo(a.dueDate));

          supplierPurchases.value = sorted;

          debugPrint(
            '[SuppliersController] Supplier purchases loaded: ${data.length}',
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[SuppliersController] loadPurchasesForSupplier error: $e');
      debugPrint('$stackTrace');

      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'SuppliersController.loadPurchasesForSupplier',
        fatal: false,
      );
    } finally {
      isLoadingSupplierPurchases.value = false;
    }
  }

  Future<void> loadPaymentsForSupplier(String supplierId) async {
    try {
      isLoadingPayments.value = true;
      supplierPayments.clear();

      final result = await getPurchasePaymentsBySupplierUsecase.call(
        supplierId,
      );

      result.fold(
        (failure) {
          debugPrint(
            '[SuppliersController] loadPaymentsForSupplier failure: ${failure.message}',
          );
        },
        (payments) {
          final sorted = [...payments]
            ..sort((a, b) => b.paymentDate.compareTo(a.paymentDate));

          supplierPayments.value = sorted;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[SuppliersController] loadPaymentsForSupplier error: $e');
      debugPrint('$stackTrace');

      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'SuppliersController.loadPaymentsForSupplier',
        fatal: false,
      );
    } finally {
      isLoadingPayments.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadData();
  }

  // ---------------------------------------------------------------------------
  // MAKE PAYMENT
  // ---------------------------------------------------------------------------

  Future<bool> makePayment({
    required String purchaseId,
    required double amount,
    required String paymentMethod,
    String? notes,
    bool silent = false,
  }) async {
    try {
      final result = await makePurchasePaymentUsecase.call(
        MakePurchasePaymentParams(
          purchaseId: purchaseId,
          amountPaid: amount,
          paymentMethod: paymentMethod,
          notes: notes,
        ),
      );

      return result.fold(
        (failure) {
          if (!silent) {
            AppSnackbar.error(
              message: failure.message.isNotEmpty
                  ? failure.message
                  : 'Failed to record payment.',
            );
          }
          return false;
        },
        (data) {
          final updatedPurchase = data.$1;
          // final payment = data.$2; // PurchasePaymentEntity, if needed later

          final index = purchases.indexWhere(
            (purchase) => purchase.id == updatedPurchase.id,
          );

          if (index != -1) {
            purchases[index] = updatedPurchase;
          } else {
            purchases.add(updatedPurchase);
          }

          if (!silent) {
            AppSnackbar.success(message: 'Payment recorded successfully.');
          }
          return true;
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[SuppliersController] makePayment error: $e');
      debugPrint('$stackTrace');

      await CrashlyticsService.recordError(
        e,
        stackTrace,
        reason: 'SuppliersController.makePayment',
        fatal: false,
      );

      if (!silent) {
        AppSnackbar.error(
          message: 'Something went wrong while recording the payment.',
        );
      }
      return false;
    }
  }

  final RxBool isMakingPayment = false.obs;

  Future<bool> makePaymentForSupplier({
    required String supplierId,
    required double amount,
    required String paymentMethod,
    String? notes,
  }) async {
    if (amount <= 0) {
      AppSnackbar.error(message: 'Enter a valid payment amount.');
      return false;
    }

    final outstanding =
        purchases
            .where(
              (purchase) =>
                  purchase.supplierId == supplierId && purchase.dueAmount > 0,
            )
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

    if (outstanding.isEmpty) {
      AppSnackbar.error(
        message: 'No outstanding purchases found for this supplier.',
      );
      return false;
    }

    isMakingPayment.value = true;

    try {
      double remaining = amount;
      double appliedSoFar = 0;

      for (final purchase in outstanding) {
        if (remaining <= 0) break;

        final payAmount = remaining >= purchase.dueAmount
            ? purchase.dueAmount
            : remaining;

        final success = await makePayment(
          purchaseId: purchase.id,
          amount: payAmount,
          paymentMethod: paymentMethod,
          notes: notes,
          silent: true,
        );

        if (!success) {
          if (appliedSoFar > 0) {
            AppSnackbar.error(
              message:
                  'Applied ₹${appliedSoFar.toStringAsFixed(2)} before a '
                  'payment failed. Please try again for the remaining amount.',
            );
          } else {
            AppSnackbar.error(message: 'Failed to record payment.');
          }
          return false;
        }

        remaining -= payAmount;
        appliedSoFar += payAmount;
      }
      Get.back();
      AppSnackbar.success(
        message: 'Payment of ₹${appliedSoFar.toStringAsFixed(2)} recorded.',
      );
      return true;
    } finally {
      isMakingPayment.value = false;
    }
  }

  void addSupplier(SupplierEntity supplier) {
    suppliers.add(supplier);
  }
}

class SupplierListItem {
  final String supplierId;
  final String initials;
  final Color avatarColor;
  final Color avatarBgColor;
  final String name;
  final String phone;
  final String location;
  final bool isActive;

  const SupplierListItem({
    required this.supplierId,
    required this.initials,
    required this.avatarColor,
    required this.avatarBgColor,
    required this.name,
    required this.phone,
    required this.location,
    required this.isActive,
  });
}
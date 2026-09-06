import 'dart:async';

import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/core/sync/bill_sync_scheduler.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/aggregate_sold_quantities_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bills_by_date_range_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_unsynced_bills_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/reduce_stock_for_sold_products_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/sync_pending_bills_usecase.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';
import 'package:billing_system/features/inventory/presentation/controller/inventory_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CategorySales {
  final String category;
  final double amount;

  const CategorySales({required this.category, required this.amount});
}

class BillingController extends GetxController {
  final GetBillsByDateRangeUsecase getBillsByDateRangeUsecase;
  final GetUnsyncedBillsUsecase getUnsyncedBillsUsecase;
  final SyncPendingBillsUsecase syncPendingBillsUsecase;
  final AggregateSoldQuantitiesUsecase aggregateSoldQuantitiesUsecase;
  final ReduceStockForSoldProductsUsecase reduceStockForSoldProductsUsecase;
  final BillSyncScheduler billSyncScheduler;

  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  final InventoryController inventoryController = Get.find();

  StreamSubscription<List<StockReductionEvent>>? _stockReductionSub;

  final RxList<BillEntity> bills = RxList<BillEntity>([]);
  final RxList<BillEntity> pending = RxList<BillEntity>([]);

  final RxBool syncing = RxBool(false);
  final RxBool loading = RxBool(false);

  final RxnString historyRestoreError = RxnString();
  final RxBool restoringHistory = RxBool(false);

  final Rx<DateTime?> lastSyncedAt = Rx<DateTime?>(null);

  BillingController({
    required this.getBillsByDateRangeUsecase,
    required this.getUnsyncedBillsUsecase,
    required this.syncPendingBillsUsecase,
    required this.aggregateSoldQuantitiesUsecase,
    required this.reduceStockForSoldProductsUsecase,
    required this.billSyncScheduler,
  });

  @override
  void onInit() {
    super.onInit();

    AnalyticsService.logScreenView('Dashboard');

    _stockReductionSub = billSyncScheduler.stockReductions.listen((events) {
      try {
        for (final e in events) {
          inventoryController.updateStockQuantityLocally(
            e.productId,
            e.newQuantity,
          );
        }
      } catch (e) {
        debugPrint('BillingController: stock UI refresh failed: $e');
      }
    });

    _initializeBilling();
  }

  @override
  void onClose() {
    _stockReductionSub?.cancel();
    super.onClose();
  }

  Future<void> _initializeBilling() async {
    loading.value = true;

    await _restoreHistory();

    await getBills();
    await getPendingBills();

    await billSyncScheduler.runIfDue();
    lastSyncedAt.value = billSyncScheduler.lastSyncedAt;

    await getBills();
    await getPendingBills();
    loading.value = false;
  }

  Future<void> _restoreHistory() async {
    restoringHistory.value = true;
    historyRestoreError.value = null;

    final result = await billSyncScheduler.hydrateIfNeeded();

    result.fold((failure) {
      historyRestoreError.value = failure.message;
      debugPrint(
        'BillingController: bill history restore failed: '
        '${failure.message}',
      );
    }, (_) {});

    restoringHistory.value = false;
  }

  Future<void> retryHistoryRestore() async {
    await _restoreHistory();
    await getBills();
  }

  Future<void> refreshBilling() async {
    await _initializeBilling();

    AnalyticsService.logEvent(
      'dashboard_refresh',
      parameters: {'status': 'success'},
    );
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void updateSearch(String value) => searchQuery.value = value;

  void clearSearch() => searchQuery.value = '';

  List<ProductEntity> get filteredProducts {
    var list = selectedCategory.value == 'All'
        ? inventoryController.products.toList()
        : inventoryController.products.where((product) {
            return inventoryController.categoryName(product.categoryId) ==
                selectedCategory.value;
          }).toList();

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list.where((p) {
        return p.name.toLowerCase().contains(query) ||
            p.sku.toLowerCase().contains(query) ||
            p.barcode.contains(query);
      }).toList();
    }

    return list;
  }

  double get todaysSalesRevenue {
    return todaysBills.fold(0.0, (sum, bill) => sum + bill.grandTotal);
  }

  int get todaysItemsSold {
    return todaysBills.fold<int>(
      0,
      (sum, bill) =>
          sum + bill.items.fold<int>(0, (s, item) => s + item.quantity.toInt()),
    );
  }

  List<BillEntity> get todaysBills {
    final now = DateTime.now();

    return bills.where((bill) {
      final date = bill.createdAt;

      return date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
    }).toList();
  }

  List<DateTime> get _last7Days {
    final now = DateTime.now();
    return List.generate(7, (i) {
      final day = now.subtract(Duration(days: 6 - i));
      return DateTime(day.year, day.month, day.day);
    });
  }

  List<String> get last7DaysLabels {
    final formatter = DateFormat('E');
    return _last7Days.map((day) => formatter.format(day)).toList();
  }

  List<FlSpot> get weeklySalesSpots {
    final days = _last7Days;

    return List.generate(days.length, (i) {
      final day = days[i];

      final total = bills
          .where((bill) {
            final d = bill.createdAt;
            return d.year == day.year &&
                d.month == day.month &&
                d.day == day.day;
          })
          .fold(0.0, (sum, bill) => sum + bill.grandTotal);

      return FlSpot(i.toDouble(), total);
    });
  }

  double get maxWeeklySales {
    final spots = weeklySalesSpots;
    if (spots.isEmpty) return 1000;

    final maxValue = spots
        .map((s) => s.y)
        .fold<double>(0, (a, b) => a > b ? a : b);

    if (maxValue == 0) return 1000;

    return maxValue * 1.2;
  }

  List<CategorySales> get salesByCategory {
    final Map<String, double> totals = {};

    for (final bill in bills) {
      for (final item in bill.items) {
        final product = inventoryController.products.firstWhereOrNull(
          (p) => p.id == item.productId,
        );

        final categoryName = product != null
            ? inventoryController.categories
                      .firstWhereOrNull((c) => c.id == product.categoryId)
                      ?.name ??
                  'Uncategorized'
            : 'Uncategorized';

        totals[categoryName] = (totals[categoryName] ?? 0) + item.total;
      }
    }

    final list = totals.entries
        .map((e) => CategorySales(category: e.key, amount: e.value))
        .toList();

    list.sort((a, b) => b.amount.compareTo(a.amount));

    return list;
  }

  double get totalCategorySales {
    return salesByCategory.fold(0.0, (sum, c) => sum + c.amount);
  }

  Future<void> getBills() async {
    try {
      final now = DateTime.now();
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      final result = await getBillsByDateRangeUsecase.call(
        DateRangeParams(start: start, end: end),
      );

      result.fold((err) {}, (data) {
        bills.value = data;
      });
    } catch (e) {
      AppSnackbar.error(message: e.toString());
    }
  }

  Future<void> getPendingBills() async {
    try {
      final result = await getUnsyncedBillsUsecase.call();

      result.fold((err) {}, (data) {
        pending.value = data;
      });
    } catch (e) {
      AppSnackbar.error(message: e.toString());
    }
  }

  void addBillLocally(BillEntity bill) {
    bills.insert(0, bill);

    if (!bill.synced) {
      pending.insert(0, bill);
    }
  }

  Future<void> syncBills() async {
    try {
      syncing.value = true;

      final pendingCountBefore = pending.length;

      await billSyncScheduler.runNow();

      await getPendingBills();
      await getBills();

      final syncedCount = pendingCountBefore - pending.length;
      if (syncedCount > 0) {
        AppSnackbar.success(
          message:
              '$syncedCount bill${syncedCount > 1 ? 's' : ''} synced successfully',
        );

        AnalyticsService.logEvent(
          'dashboard_sync_bills',
          parameters: {'status': 'success', 'synced_count': syncedCount},
        );
      }
    } catch (e) {
      AppSnackbar.error(message: e.toString());

      AnalyticsService.logEvent(
        'dashboard_sync_bills',
        parameters: {'status': 'error', 'error': e.toString()},
      );
    } finally {
      syncing.value = false;
      lastSyncedAt.value = billSyncScheduler.lastSyncedAt;
    }
  }

  String formatCompactValue(double value) {
    if (value >= 1000000) {
      return '${_trimZero(value / 1000000)}M';
    } else if (value >= 1000) {
      return '${_trimZero(value / 1000)}k';
    }
    return value.toStringAsFixed(0);
  }

  String _trimZero(double value) {
    return value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }
}

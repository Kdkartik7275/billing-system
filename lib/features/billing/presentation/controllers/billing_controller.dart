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

  // Dashboard-scoped: last 7 days only.
  final RxList<BillEntity> bills = RxList<BillEntity>([]);

  // Sync-scoped: every unsynced bill regardless of age.
  final RxList<BillEntity> pending = RxList<BillEntity>([]);

  final RxBool syncing = RxBool(false);

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
    _initializeBilling();
  }

  Future<void> _initializeBilling() async {
    await billSyncScheduler.hydrateIfNeeded();

    await getBills();
    await getPendingBills();

    await billSyncScheduler.runIfDue();

    await getPendingBills();
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

  // ---------------- WEEKLY SALES (LINE CHART) ----------------

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

  // ---------------- SALES BY CATEGORY (PIE CHART) ----------------

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

  // ---------------- BILLS (DASHBOARD WINDOW: LAST 7 DAYS) ----------------

  Future<void> getBills() async {
    try {
      final now = DateTime.now();
      final start = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(const Duration(days: 6));
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

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

  // ---------------- PENDING (UNSYNCED, ANY DATE) ----------------

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

  // ---------------- SYNC + STOCK REDUCTION ----------------

  Future<void> syncBills() async {
    try {
      syncing.value = true;
      final result = await syncPendingBillsUsecase.call();

      await result.fold((err) async => AppSnackbar.error(message: err.message), (
        syncedBills,
      ) async {
        if (syncedBills.isEmpty) return;

        await getPendingBills();

        final aggregateResult = await aggregateSoldQuantitiesUsecase(
          syncedBills,
        );

        await aggregateResult.fold((_) async {}, (aggregates) async {
          if (aggregates.isEmpty) return;

          final reductionResult = await reduceStockForSoldProductsUsecase(
            aggregates,
          );

          reductionResult.fold((_) {}, (reductions) {
            final inventoryController = Get.find<InventoryController>();
            for (final r in reductions) {
              inventoryController.updateStockQuantityLocally(
                r.productId,
                r.newQuantity,
              );
            }
          });
        });

        AppSnackbar.success(
          message:
              '${syncedBills.length} bill${syncedBills.length > 1 ? 's' : ''} synced successfully',
        );
      });
    } catch (e) {
      AppSnackbar.error(message: e.toString());
    } finally {
      syncing.value = false;
    }
  }
}

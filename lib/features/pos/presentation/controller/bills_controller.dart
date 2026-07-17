import 'package:billing_system/core/helper/bill_dashboard_extension.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/usecases/get_products_byids.dart';
import 'package:billing_system/features/inventory/domain/usecases/sell_stock.dart';
import 'package:billing_system/features/inventory/domain/usecases/sync_products.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/usecases/get_biils_usecase.dart';
import 'package:billing_system/features/pos/domain/usecases/get_last_seven_days_sales.dart';
import 'package:billing_system/features/pos/domain/usecases/get_pending_bills.dart';
import 'package:billing_system/features/pos/domain/usecases/sync_pending_bills.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class BillsController extends GetxController {
  final GetBillsUsecase getBillsUseCase;
  final SyncPendingBillsUsecase syncBillsUseCase;
  final SyncProductsUsecase syncProductsUseCase;
  final GetLastSevenDaysSales getLastSevenDaysSalesUseCase;
  final GetPendingBillsUseCase getPendingBillsUseCase;
  final GetProductsByids getProductsByIdsUseCase;
  final SellStockUseCase sellStockUseCase;

  RxBool isLoading = RxBool(false);
  final isSyncing = false.obs;

  RxList<BillEntity> bills = RxList<BillEntity>([]);
  RxList<BillEntity> sales = RxList<BillEntity>([]);
  RxList<BillEntity> pendingSyncedBills = RxList<BillEntity>([]);

  BillsController({
    required this.getBillsUseCase,
    required this.syncBillsUseCase,
    required this.syncProductsUseCase,
    required this.getLastSevenDaysSalesUseCase,
    required this.getPendingBillsUseCase,
    required this.getProductsByIdsUseCase,
    required this.sellStockUseCase,
  });

  List<BillEntity> get todayBills {
    final today = DateTime.now();

    final result = bills
        .where(
          (b) =>
              b.createdAt.year == today.year &&
              b.createdAt.month == today.month &&
              b.createdAt.day == today.day,
        )
        .toList();

    result.sort((b1, b2) => b2.createdAt.compareTo(b1.createdAt));

    return result;
  }

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([getBills(), getLastSevenDaysSales(), getPendingBills()]);
  }

  double get todaySales =>
      todayBills.fold(0, (sum, b) => sum + b.subtotal + b.taxAmount);

  double get todayRevenue => todayBills.fold(0, (sum, b) => sum + b.subtotal);

  int get todayOrderCount => todayBills.length;

  int get pendingSyncCount => pendingSyncedBills.length;

  Future<void> getBills() async {
    try {
      isLoading.value = true;
      final result = await getBillsUseCase.call(DateTime.now());
      result.fold(
        (failure) {
          AppSnackbar.error(
            message:
                'An error occurred while fetching bills: ${failure.message}',
          );
        },
        (billsList) {
          bills.value = billsList;
        },
      );
    } catch (e) {
      AppSnackbar.error(message: 'An error occurred while fetching bills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPendingBills() async {
    try {
      isLoading.value = true;
      final result = await getPendingBillsUseCase.call();
      result.fold(
        (failure) {
          AppSnackbar.error(
            message:
                'An error occurred while fetching bills: ${failure.message}',
          );
        },
        (billsList) {
          pendingSyncedBills.value = billsList;
        },
      );
    } catch (e) {
      AppSnackbar.error(message: 'An error occurred while fetching bills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getLastSevenDaysSales() async {
    try {
      isLoading.value = true;
      final result = await getLastSevenDaysSalesUseCase.call();
      result.fold(
        (failure) {
          AppSnackbar.error(
            message:
                'An error occurred while fetching bills: ${failure.message}',
          );
        },
        (billsList) {
          sales.value = billsList;
        },
      );
    } catch (e) {
      AppSnackbar.error(message: 'An error occurred while fetching bills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncAll() async {
    if (isSyncing.value) return;

    isSyncing.value = true;

    try {
      // No pending bills
      if (pendingSyncedBills.isEmpty) {
        AppSnackbar.success(message: 'No pending bills to sync.');
        return;
      }

      /// Get unique product ids
      final productIds = pendingSyncedBills
          .expand((bill) => bill.items)
          .map((item) => item.productId)
          .toSet()
          .toList();

      /// Fetch current product stocks
      final Map<String, int> currentStocks = {};

      final productsResult = await getProductsByIdsUseCase(productIds);

      final fetchSuccess = productsResult.fold(
        (failure) {
          AppSnackbar.error(
            message:
                'An error occurred while fetching products: ${failure.message}',
          );
          return false;
        },
        (products) {
          for (final product in products) {
            currentStocks[product.id] = product.stock;
          }
          return true;
        },
      );

      if (!fetchSuccess) return;

      /// Aggregate sold quantity for each product
      final Map<String, int> soldQuantities = {};

      for (final bill in pendingSyncedBills) {
        for (final item in bill.items) {
          soldQuantities.update(
            item.productId,
            (value) => value + item.quantity,
            ifAbsent: () => item.quantity,
          );
        }
      }

      /// Prepare inventory update data
      final List<Map<String, dynamic>> inventoryProductsData = soldQuantities
          .entries
          .map((entry) {
            final currentStock = currentStocks[entry.key] ?? 0;

            return {
              'id': entry.key,
              'quantity': entry.value,
              'previousStock': currentStock + entry.value,
            };
          })
          .toList();

      /// Debug logs
      for (final product in inventoryProductsData) {
        print('''
Product ID      : ${product['id']}
Quantity Sold   : ${product['quantity']}
Previous Stock  : ${product['previousStock']}
New Stock       : ${product['previousStock'] - product['quantity']}
----------------------------------------
''');
      }

      /// Sync bills
      final syncBillsResult = await syncBillsUseCase(pendingSyncedBills);

      final billsSynced = await syncBillsResult.fold(
        (failure) async {
          AppSnackbar.error(
            message:
                'An error occurred while syncing bills: ${failure.message}',
          );
          return false;
        },
        (_) async {
          final productsData = soldQuantities.entries
              .map((entry) => {'id': entry.key, 'quantity': entry.value})
              .toList();

          await syncProductsUseCase(productsData);

          pendingSyncedBills.clear();

          return true;
        },
      );

      if (!billsSynced) return;

      /// Update stock history
      for (final product in inventoryProductsData) {
        final result = await sellStockUseCase(
          SellStockParams(
            productId: product['id'],
            quantity: product['quantity'],
            previousStock: product['previousStock'],
          ),
        );

        result.fold(
          (failure) {
            AppSnackbar.error(
              message:
                  'Failed to update stock for ${product['id']}: ${failure.message}',
            );
          },
          (_) {
            print('Stock history updated for ${product['id']}');
          },
        );
      }

      AppSnackbar.success(
        message: 'All pending bills have been synced successfully!',
      );
    } finally {
      isSyncing.value = false;
    }
  }

  List<String> get last7DaysLabels => sales.getLast7DaysLabels();

  List<FlSpot> get weeklySalesSpots => sales.getWeeklySalesSpots();

  double get maxWeeklySales => sales.getMaxWeeklySales();

  List<CategorySales> get salesByCategory => sales.getSalesByCategory();

  double get totalCategorySales => sales.getTotalCategorySales();
}

import 'package:billing_system/core/helper/bill_dashboard_extension.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/inventory/domain/usecases/sync_products.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/domain/usecases/get_biils_usecase.dart';
import 'package:billing_system/features/pos/domain/usecases/get_last_seven_days_sales.dart';
import 'package:billing_system/features/pos/domain/usecases/sync_pending_bills.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class BillsController extends GetxController {
  final GetBillsUsecase getBillsUseCase;
  final SyncPendingBillsUsecase syncBillsUseCase;
  final SyncProductsUsecase syncProductsUseCase;
  final GetLastSevenDaysSales getLastSevenDaysSalesUseCase;

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
    await Future.wait([getBills(), getLastSevenDaysSales()]);
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
          pendingSyncedBills.value = billsList
              .where((bill) => bill.isOfflineCreated == true)
              .toList();
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
      final result = await syncBillsUseCase.call(pendingSyncedBills);
      result.fold(
        (failure) {
          AppSnackbar.error(
            message:
                'An error occurred while syncing bills: ${failure.message}',
          );
        },
        (_) async {
          List<Map<String, dynamic>> productsData = pendingSyncedBills
              .expand((bill) => bill.items)
              .map((item) => {'id': item.productId, 'quantity': item.quantity})
              .toList();
          await syncProductsUseCase.call(productsData);
          pendingSyncedBills.clear();
        },
      );

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

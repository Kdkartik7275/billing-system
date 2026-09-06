import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/core/helper/export_sales_data.dart';
import 'package:billing_system/core/helper/print_bill.dart';
import 'package:billing_system/core/services/analytics/analytics_service.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bill_by_invoice_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bills_by_date_range_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bills_by_date_usecase.dart';
import 'package:billing_system/features/sales/presentation/widgets/bill_details_dialog.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';

enum SalesFilter { all, cash, upi, card, credit }

extension SalesFilterX on SalesFilter {
  String get label {
    switch (this) {
      case SalesFilter.all:
        return 'All Sales';
      case SalesFilter.cash:
        return 'Cash';
      case SalesFilter.upi:
        return 'UPI';
      case SalesFilter.card:
        return 'Card';
      case SalesFilter.credit:
        return 'Credit';
    }
  }

  PaymentMethod? get toPaymentMethod {
    switch (this) {
      case SalesFilter.all:
        return null;
      case SalesFilter.cash:
        return PaymentMethod.cash;
      case SalesFilter.upi:
        return PaymentMethod.upi;
      case SalesFilter.card:
        return PaymentMethod.card;
      case SalesFilter.credit:
        return PaymentMethod.other;
    }
  }
}

class SalesController extends GetxController {
  final GetBillsByDateUsecase getBillsByDateUsecase;
  final GetBillByInvoiceUsecase getBillByInvoiceUsecase;
  final GetBillsByDateRangeUsecase getBillsByDateRangeUsecase;

  SalesController({
    required this.getBillsByDateUsecase,
    required this.getBillByInvoiceUsecase,
    required this.getBillsByDateRangeUsecase,
  });

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final Rx<SalesFilter> selectedFilter = SalesFilter.all.obs;

  final RxList<BillEntity> bills = <BillEntity>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  /// Guards the export button. A PDF build for a full month can take a
  /// second or two, and a double-tap would otherwise open two share sheets.
  final RxBool isExporting = false.obs;

  @override
  void onInit() {
    super.onInit();
    AnalyticsService.logScreenView('Sales');

    loadBills();
  }

  Future<void> loadBills() async {
    isLoading.value = true;
    errorMessage.value = '';

    final result = await getBillsByDateUsecase(selectedDate.value);

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
        bills.clear();
      },
      (data) {
        bills.assignAll(data);
      },
    );

    isLoading.value = false;
  }

  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;

    selectedFilter.value = SalesFilter.all;

    await loadBills();
  }

  void selectFilter(SalesFilter filter) {
    selectedFilter.value = filter;
  }

  List<BillEntity> get filteredBills {
    final method = selectedFilter.value.toPaymentMethod;

    final result = bills.where((bill) {
      // Payment method filter
      final matchesMethod =
          method == null ||
          bill.payment.payments.any((payment) => payment.method == method);

      return matchesMethod;
    }).toList();

    // Newest first
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return result;
  }

  double get totalSales {
    return filteredBills.fold(0.0, (sum, bill) => sum + bill.grandTotal);
  }

  int get totalBills {
    return filteredBills.length;
  }

  int get totalItems {
    return filteredBills.fold<int>(0, (sum, bill) {
      return sum +
          bill.items.fold<int>(
            0,
            (itemSum, item) => itemSum + item.quantity.toInt(),
          );
    });
  }

  // --------------------------------------------------------------------
  // EXPORT
  // --------------------------------------------------------------------

  /// Builds a sales report PDF for [range] and hands it to the platform
  /// share sheet.
  Future<void> exportSales(SalesExportRange range) async {
    if (isExporting.value) return;

    isExporting.value = true;

    try {
      final result = await getBillsByDateRangeUsecase(
        DateRangeParams(start: range.start, end: range.end),
      );

      String? failureMessage;
      List<BillEntity> allBills = const <BillEntity>[];

      result.fold<void>(
        (failure) {
          failureMessage = failure.message.isNotEmpty
              ? failure.message
              : 'Could not load sales for this period.';
        },
        (loadedBills) {
          allBills = loadedBills;
        },
      );

      if (failureMessage != null) {
        AppSnackbar.error(message: failureMessage!);

        await AnalyticsService.logEvent(
          'sales_export_failed',
          parameters: {
            'range': range.label,
            'error': failureMessage!,
            'filter': selectedFilter.value.label,
          },
        );

        return;
      }

      final method = selectedFilter.value.toPaymentMethod;
      final scopedBills = method == null
          ? allBills
          : allBills
                .where(
                  (bill) => bill.payment.payments.any(
                    (payment) => payment.method == method,
                  ),
                )
                .toList();

      if (scopedBills.isEmpty) {
        AppSnackbar.info(
          message: 'No sales found for ${range.label}.',
          title: 'Nothing to export',
        );

        await AnalyticsService.logEvent(
          'sales_export',
          parameters: {
            'range': range.label,
            'filter': selectedFilter.value.label,
            'status': 'empty',
            'bills_count': 0,
          },
        );

        return;
      }

      final rows = scopedBills.map(SalesExportRow.fromBill).toList();

      final shopName = Get.isRegistered<UserController>()
          ? Get.find<UserController>().shop.value?.shopName
          : null;

      final export = await const SalesPdfExporter().export(
        rows: rows,
        range: range,
        shopName: shopName,
        paymentFilterLabel: selectedFilter.value == SalesFilter.all
            ? null
            : selectedFilter.value.label,
      );

      await Printing.sharePdf(bytes: export.bytes, filename: export.fileName);

      await AnalyticsService.logEvent(
        'sales_export',
        parameters: {
          'range': range.label,
          'filter': selectedFilter.value.label,
          'status': 'success',
          'bills_count': scopedBills.length,
          'total_amount': scopedBills.fold<double>(
            0.0,
            (sum, bill) => sum + bill.grandTotal,
          ),
        },
      );
    } catch (e) {
      AppSnackbar.error(message: 'Export failed: $e');
      debugPrint('Sales export failed: $e');

      await AnalyticsService.logEvent(
        'sales_export_failed',
        parameters: {
          'range': range.label,
          'filter': selectedFilter.value.label,
          'error': e.toString(),
        },
      );
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> handleScannedBill(String invoiceNo) async {
    try {
      if (invoiceNo.trim().isEmpty) {
        AppSnackbar.error(
          message: 'Invalid QR code. No invoice number was found.',
        );
        return;
      }

      final result = await getBillByInvoiceUsecase.call(invoiceNo.trim());

      result.fold(
        (failure) {
          AppSnackbar.error(
            message: failure.message.isNotEmpty
                ? failure.message
                : 'Unable to fetch the bill. Please try again.',
          );
        },
        (bill) {
          if (bill != null) {
            showDialog(
              context: Get.context!,
              builder: (_) => BillDetailsDialog(
                bill: bill,
                onPrintReceipt: () => printBill(
                  bill: bill,
                  shop: Get.find<UserController>().shop.value!,
                ),
              ),
            );
          } else {
            AppSnackbar.error(
              message: 'Bill not found for invoice "$invoiceNo".',
            );
          }
        },
      );
    } catch (e) {
      AppSnackbar.error(
        message: 'Something went wrong while fetching the bill.',
      );
    }
  }
}

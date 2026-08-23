import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/core/helper/print_bill.dart';
import 'package:billing_system/core/snackbars/snackbars.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bill_by_invoice_usecase.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bills_by_date_usecase.dart';
import 'package:billing_system/features/sales/presentation/widgets/bill_details_dialog.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  SalesController({
    required this.getBillsByDateUsecase,
    required this.getBillByInvoiceUsecase,
  });

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final Rx<SalesFilter> selectedFilter = SalesFilter.all.obs;

  final RxList<BillEntity> bills = <BillEntity>[].obs;

  final RxBool isLoading = false.obs;

  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

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

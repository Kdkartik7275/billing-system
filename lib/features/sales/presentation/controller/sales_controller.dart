import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bills_by_date_usecase.dart';
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

  SalesController({required this.getBillsByDateUsecase});

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final Rx<SalesFilter> selectedFilter = SalesFilter.all.obs;

  final RxString searchQuery = ''.obs;

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
    searchQuery.value = '';

    await loadBills();
  }

  void selectFilter(SalesFilter filter) {
    selectedFilter.value = filter;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<BillEntity> get filteredBills {
    final method = selectedFilter.value.toPaymentMethod;
    final query = searchQuery.value.trim().toLowerCase();

    final result = bills.where((bill) {
      // Payment method filter
      final matchesMethod =
          method == null ||
          bill.payment.payments.any((payment) => payment.method == method);

      // Search filter
      final matchesSearch =
          query.isEmpty ||
          bill.billNumber.toLowerCase().contains(query) ||
          (bill.customer?.name.toLowerCase().contains(query) ?? false);

      return matchesMethod && matchesSearch;
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
}

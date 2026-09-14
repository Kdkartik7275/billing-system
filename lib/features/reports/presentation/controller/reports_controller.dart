import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/usecases/get_bills_by_date_usecase.dart';
import 'package:billing_system/features/reports/domain/entities/cash_reconciliation_entity.dart';
import 'package:billing_system/features/reports/domain/entities/report_entity.dart';
import 'package:billing_system/features/reports/domain/entities/sales_summary_entity.dart';
import 'package:billing_system/features/reports/domain/entities/tender_breakdown_entity.dart';
import 'package:billing_system/features/reports/domain/usecases/generate_report_usecase.dart';
import 'package:billing_system/features/reports/domain/usecases/get_report_by_id.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DayStatus { open, closed }

class TenderSlice {
  final String label;
  final double amount;
  final Color color;

  const TenderSlice({
    required this.label,
    required this.amount,
    required this.color,
  });
}

class ReportsController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final GenerateReportUsecase generateReportUsecase;
  final GetReportByIdUsecase getReportByIdUsecase;
  final GetBillsByDateUsecase getBillsByDateUsecase;

  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxDouble openingCashFloat = 0.0.obs;
  final RxDouble payouts = 0.0.obs;
  final Rxn<double> countedCash = Rxn<double>();
  final Rx<DayStatus> dayStatus = DayStatus.open.obs;

  final RxList<BillEntity> billsForDate = <BillEntity>[].obs;
  final RxBool isLoadingBills = false.obs;

  /// The last successfully generated/saved/fetched report, if any.
  final Rxn<ReportEntity> currentReport = Rxn<ReportEntity>();
  final RxBool isGeneratingReport = false.obs;
  final RxBool isLoadingReport = false.obs;
  final RxnString reportError = RxnString();

  ReportsController({
    required this.generateReportUsecase,
    required this.getReportByIdUsecase,
    required this.getBillsByDateUsecase,
  });

  @override
  void onInit() {
    super.onInit();
    fetchReportForDate(selectedDate.value);
  }

  void setOpeningFloat(double value) => openingCashFloat.value = value;

  void setPayouts(double value) => payouts.value = value;

  void setCountedCash(double value) => countedCash.value = value;

  Future<bool> closeDay() async {
    // generateReport() reads dayStatus to decide whether to stamp
    // closedAt/closedBy, so flip it before saving...
    dayStatus.value = DayStatus.closed;

    final saved = await generateReport();

    if (!saved) {
      // ...and roll back if the save actually failed, so the UI and
      // the persisted report never disagree about whether the day
      // was closed.
      dayStatus.value = DayStatus.open;
    }

    return saved;
  }

  // ---------------- DATE SELECTION ----------------

  Future<void> selectDate(DateTime date) async {
    await fetchReportForDate(date);
  }

  // ---------------- FETCH REPORT FOR DATE ----------------

  Future<void> fetchReportForDate(DateTime date) async {
    selectedDate.value = date;
    isLoadingReport.value = true;
    reportError.value = null;

    try {
      final businessDate = _dateOnly(date);

      // Bills and the persisted report are independent lookups — load
      // them together instead of one blocking the other.
      final results = await Future.wait([
        _loadBillsForDate(businessDate),
        _fetchExistingReport(businessDate),
      ]);

      final failureMessage = results[1] as String?;
      if (failureMessage != null) {
        reportError.value = failureMessage;
      }
    } catch (e, stackTrace) {
      reportError.value = e.toString();
      debugPrint('[ReportsController] fetchReportForDate error: $e');
      debugPrint('$stackTrace');
    } finally {
      isLoadingReport.value = false;
    }
  }

  Future<void> _loadBillsForDate(DateTime date) async {
    isLoadingBills.value = true;
    try {
      final result = await getBillsByDateUsecase.call(date);

      billsForDate.value = result.fold((failure) {
        debugPrint(
          '[ReportsController] loadBillsForDate failed: ${failure.message}',
        );
        return <BillEntity>[];
      }, (list) => list);
    } catch (e, stackTrace) {
      debugPrint('[ReportsController] loadBillsForDate error: $e');
      debugPrint('$stackTrace');
      billsForDate.value = [];
    } finally {
      isLoadingBills.value = false;
    }
  }

  /// Fetches the persisted report for [businessDate] and applies it, or
  /// resets to a fresh open day if none exists yet. Returns a non-null
  /// error message on failures other than "not found".
  Future<String?> _fetchExistingReport(DateTime businessDate) async {
    final id = _reportIdFor(businessDate);
    final result = await getReportByIdUsecase.call(id);

    String? errorMessage;

    await result.fold((failure) async {
      if (_isNotFoundFailure(failure.message)) {
        await _resetToFreshDay(businessDate);
      } else {
        errorMessage = failure.message;
        debugPrint(
          '[ReportsController] fetchReportForDate failed: '
          '${failure.message}',
        );
      }
    }, (report) async => _applyReport(report));

    return errorMessage;
  }

  bool _isNotFoundFailure(String? message) => message == 'Report not found';

  void _applyReport(ReportEntity report) {
    currentReport.value = report;
    dayStatus.value = report.status == ReportStatus.closed
        ? DayStatus.closed
        : DayStatus.open;
    openingCashFloat.value = report.cashReconciliation.openingCashFloat;
    payouts.value = report.cashReconciliation.payouts;
    countedCash.value = report.cashReconciliation.countedCash;
  }

  static const double _defaultOpeningCashFloat = 5000.0;

  Future<void> _resetToFreshDay(DateTime businessDate) async {
    currentReport.value = null;
    dayStatus.value = DayStatus.open;
    payouts.value = 0.0;
    countedCash.value = null;
    openingCashFloat.value = await _resolveOpeningFloatFor(businessDate);
  }

  Future<double> _resolveOpeningFloatFor(DateTime businessDate) async {
    try {
      final previousDate = businessDate.subtract(const Duration(days: 1));
      final previousId = _reportIdFor(previousDate);

      final result = await getReportByIdUsecase.call(previousId);

      return result.fold(
        (failure) => _defaultOpeningCashFloat,
        (previousReport) =>
            previousReport.cashReconciliation.countedCash ??
            previousReport.cashReconciliation.expectedCash,
      );
    } catch (e) {
      debugPrint('[ReportsController] _resolveOpeningFloatFor error: $e');
      return _defaultOpeningCashFloat;
    }
  }

  // ---------------- GENERATE REPORT ----------------

  Future<bool> generateReport() async {
    isGeneratingReport.value = true;
    reportError.value = null;

    try {
      final user = userController.user.value;
      if (user == null) {
        reportError.value = 'No signed-in user found.';
        return false;
      }
      final shopId = user.shopId;
      final businessDate = _dateOnly(selectedDate.value);
      final now = DateTime.now();

      final report = ReportEntity(
        id: _reportIdFor(businessDate),
        shopId: shopId,
        businessDate: businessDate,
        status: ReportStatus.closed,
        closedAt: now,
        closedBy: user.uid,
        cashReconciliation: CashReconciliationEntity(
          openingCashFloat: openingCashFloat.value,
          cashSales: cashSales,
          cashRefunds: refundsAmount,
          payouts: payouts.value,
          expectedCash: expectedCash,
          countedCash: countedCash.value,
          variance: hasCountedCash ? variance : null,
        ),
        tenderBreakdown: TenderBreakdownEntity(
          cash: cashSales,
          upi: upiSales,
          card: cardSales,
          other: otherSales,
        ),
        salesSummary: SalesSummaryEntity(
          totalSales: totalSales,
          totalBills: totalBillsCount,
          voidAmount: voidsAmount,
          voidCount: voidsCount,
          discountsGiven: discountsGivenAmount,
          discountedBillCount: discountBillsCount,
          refunds: refundsAmount,
          refundCount: refundsCount,
          taxAmount: 0,
        ),
        createdAt: currentReport.value?.createdAt ?? now,
        updatedAt: now,
      );

      final result = await generateReportUsecase.call(report);

      return result.fold(
        (failure) {
          reportError.value = failure.message;
          debugPrint(
            '[ReportsController] generateReport failed: '
            '${failure.message}',
          );
          return false;
        },
        (savedReport) {
          currentReport.value = savedReport;
          return true;
        },
      );
    } catch (e, stackTrace) {
      reportError.value = e.toString();
      debugPrint('[ReportsController] generateReport error: $e');
      debugPrint('$stackTrace');
      return false;
    } finally {
      isGeneratingReport.value = false;
    }
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  String _reportIdFor(DateTime businessDate) {
    final dateKey =
        '${businessDate.year.toString().padLeft(4, '0')}-'
        '${businessDate.month.toString().padLeft(2, '0')}-'
        '${businessDate.day.toString().padLeft(2, '0')}';
    return dateKey;
  }

  // ---------------- BILLS BREAKDOWN (derived from billsForDate) ----------------

  List<BillEntity> get _completedBills =>
      billsForDate.where((b) => b.status == BillStatus.completed).toList();

  List<BillEntity> get _voidBills =>
      billsForDate.where((b) => b.status == BillStatus.cancelled).toList();

  List<BillEntity> get _refundBills =>
      billsForDate.where((b) => b.status == BillStatus.refunded).toList();

  // ---------------- SALES SUMMARY ----------------

  double get totalSales =>
      _completedBills.fold(0.0, (sum, b) => sum + b.grandTotal);

  int get totalBillsCount => _completedBills.length;

  double _salesForMethod(PaymentMethod method) {
    return _completedBills
        .where((b) => b.payment.payments.any((p) => p.method == method))
        .fold(0.0, (sum, b) => sum + b.grandTotal);
  }

  double get cashSales => _salesForMethod(PaymentMethod.cash);
  double get cardSales => _salesForMethod(PaymentMethod.card);
  double get upiSales => _salesForMethod(PaymentMethod.upi);

  double get otherSales {
    final accounted = cashSales + cardSales + upiSales;
    final remaining = totalSales - accounted;
    return remaining < 0 ? 0 : remaining;
  }

  int _billCountForMethod(PaymentMethod method) => _completedBills
      .where((b) => b.payment.payments.any((p) => p.method == method))
      .length;

  int get cashBillsCount => _billCountForMethod(PaymentMethod.cash);
  int get cardBillsCount => _billCountForMethod(PaymentMethod.card);
  int get upiBillsCount => _billCountForMethod(PaymentMethod.upi);

  // ---------------- VOIDS / DISCOUNTS / REFUNDS ----------------

  int get voidsCount => _voidBills.length;
  double get voidsAmount =>
      _voidBills.fold(0.0, (sum, b) => sum + b.grandTotal);

  int get refundsCount => _refundBills.length;
  double get refundsAmount =>
      _refundBills.fold(0.0, (sum, b) => sum + b.grandTotal);

  List<BillEntity> get _discountedBills =>
      _completedBills.where((b) => b.discount > 0).toList();

  int get discountBillsCount => _discountedBills.length;
  double get discountsGivenAmount =>
      _discountedBills.fold(0.0, (sum, b) => sum + b.discount);

  // ---------------- CASH RECONCILIATION ----------------

  double get expectedCash =>
      openingCashFloat.value + cashSales - refundsAmount - payouts.value;

  double get variance => (countedCash.value ?? expectedCash) - expectedCash;

  bool get hasCountedCash => countedCash.value != null;

  String get varianceLabel {
    if (!hasCountedCash) return '';
    if (variance == 0) return 'Balanced';
    return variance < 0 ? 'Shortage' : 'Overage';
  }

  // ---------------- TENDER BREAKDOWN ----------------

  List<TenderSlice> get tenderBreakdown {
    final slices = <TenderSlice>[
      TenderSlice(
        label: 'Cash',
        amount: cashSales,
        color: const Color(0xff2962FF),
      ),
      TenderSlice(
        label: 'UPI',
        amount: upiSales,
        color: const Color(0xffEF6C00),
      ),
      TenderSlice(
        label: 'Card',
        amount: cardSales,
        color: const Color(0xff12B76A),
      ),
      TenderSlice(
        label: 'Others',
        amount: otherSales,
        color: Colors.grey.shade500,
      ),
    ];
    return slices.where((s) => s.amount > 0).toList();
  }
}

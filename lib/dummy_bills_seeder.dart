import 'dart:math';

import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/domain/entities/bill_item_entity.dart';
import 'package:billing_system/features/billing/domain/entities/payment_entity.dart';
import 'package:billing_system/features/billing/domain/entities/payment_summary_entity.dart';
import 'package:billing_system/features/inventory/domain/entities/product_entity.dart';

import 'package:uuid/uuid.dart';

class DummyBillsData {
  DummyBillsData._();

  static const Uuid _uuid = Uuid();
  static final Random _random = Random();

  static const List<PaymentMethod> _paymentMethods = [
    PaymentMethod.cash,
    PaymentMethod.cash,
    PaymentMethod.cash,
    PaymentMethod.upi,
    PaymentMethod.upi,
    PaymentMethod.card,
    PaymentMethod.wallet,
    PaymentMethod.other,
  ];

  /// Generates bills for every day between [startDate] and [endDate].
  ///
  /// The products passed here should come from the products created by
  /// DummyDataSeeder and loaded into InventoryController.
  static List<BillEntity> generateBillsForDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required List<ProductEntity> products,
    int minBillsPerDay = 3,
    int maxBillsPerDay = 12,
    int minItemsPerBill = 1,
    int maxItemsPerBill = 6,
    String cashierId = 'dummy_cashier',
    String warehouseId = 'Main Store',
    bool synced = false,
    bool stockApplied = false,
  }) {
    _validate(
      startDate: startDate,
      endDate: endDate,
      products: products,
      minBillsPerDay: minBillsPerDay,
      maxBillsPerDay: maxBillsPerDay,
      minItemsPerBill: minItemsPerBill,
      maxItemsPerBill: maxItemsPerBill,
    );

    final usableProducts = products
        .where((product) => product.price.sellingPrice > 0)
        .toList();

    final bills = <BillEntity>[];

    var currentDate = _dateOnly(startDate);
    final lastDate = _dateOnly(endDate);
    var sequence = 1;

    while (!currentDate.isAfter(lastDate)) {
      final billsToday = _randomBetween(minBillsPerDay, maxBillsPerDay);

      for (var billIndex = 0; billIndex < billsToday; billIndex++) {
        final billDateTime = _randomTimeOnDate(currentDate);

        final itemCount = _randomBetween(minItemsPerBill, maxItemsPerBill);

        final selectedProducts = _pickRandomProducts(usableProducts, itemCount);

        if (selectedProducts.isEmpty) {
          continue;
        }

        final items = _createBillItems(selectedProducts);

        final subtotal = items.fold<double>(
          0,
          (sum, item) => sum + item.unitPrice * item.quantity,
        );

        final tax = items.fold<double>(0, (sum, item) => sum + item.tax);

        final discount = _randomDiscount();

        final grandTotal = max(0.0, subtotal + tax - discount);

        final paymentMethod = _randomPaymentMethod();

        final paidAmount = _calculatePaidAmount(
          total: grandTotal,
          method: paymentMethod,
        );

        final payment = PaymentEntity(
          id: _uuid.v4(),
          method: paymentMethod,
          amount: paidAmount,
          paidAt: billDateTime,
        );

        final paymentSummary = PaymentSummaryEntity(
          payments: [payment],
          paidAmount: paidAmount,
          changeAmount: max(0.0, paidAmount - grandTotal),
          pendingAmount: 0,
        );

        bills.add(
          BillEntity(
            id: _uuid.v4(),
            billNumber: _billNumber(date: currentDate, sequence: sequence),
            cashierId: cashierId,
            customer: null,
            items: items,
            subTotal: _round(subtotal),
            discount: _round(discount),
            tax: _round(tax),
            grandTotal: _round(grandTotal),
            payment: paymentSummary,
            status: BillStatus.completed,
            synced: synced,
            stockApplied: stockApplied,
            createdAt: billDateTime,
            updatedAt: billDateTime,
            warehouseId: warehouseId,
          ),
        );

        sequence++;
      }

      currentDate = currentDate.add(const Duration(days: 1));
    }

    return bills;
  }

  /// Generates bills for the last [days] calendar days, including today.
  static List<BillEntity> generateLastNDays({
    required List<ProductEntity> products,
    int days = 60,
    int minBillsPerDay = 3,
    int maxBillsPerDay = 12,
    int minItemsPerBill = 1,
    int maxItemsPerBill = 6,
    String cashierId = 'dummy_cashier',
    String warehouseId = 'Main Store',
    bool synced = true,
    bool stockApplied = false,
  }) {
    if (days <= 0) {
      throw ArgumentError.value(days, 'days', 'days must be greater than zero');
    }

    final today = _dateOnly(DateTime.now());

    final startDate = today.subtract(Duration(days: days - 1));

    return generateBillsForDateRange(
      startDate: startDate,
      endDate: today,
      products: products,
      minBillsPerDay: minBillsPerDay,
      maxBillsPerDay: maxBillsPerDay,
      minItemsPerBill: minItemsPerBill,
      maxItemsPerBill: maxItemsPerBill,
      cashierId: cashierId,
      warehouseId: warehouseId,
      synced: synced,
      stockApplied: stockApplied,
    );
  }

  static List<BillItemEntity> _createBillItems(List<ProductEntity> products) {
    return products.map((product) {
      final quantity = _randomBetween(1, 3).toDouble();

      final unitPrice = product.price.sellingPrice;

      // Same calculation used in CheckoutController.
      final taxAmount = product.tax.taxAmountFor(unitPrice) * quantity;

      // Same calculation used in CheckoutController.
      final lineTotal = product.finalSellingPrice * quantity;

      return BillItemEntity(
        id: _uuid.v4(),
        productId: product.id,
        productName: product.name,
        sku: product.sku,
        barcode: product.barcode,
        quantity: quantity,
        unitPrice: unitPrice,
        mrp: product.price.mrp ?? unitPrice,
        discount: 0,
        taxPercent: product.tax.gstPercent,
        tax: _round(taxAmount),
        total: _round(lineTotal),
      );
    }).toList();
  }

  static List<ProductEntity> _pickRandomProducts(
    List<ProductEntity> products,
    int count,
  ) {
    final shuffledProducts = List<ProductEntity>.from(products)
      ..shuffle(_random);

    return shuffledProducts.take(min(count, shuffledProducts.length)).toList();
  }

  static PaymentMethod _randomPaymentMethod() {
    return _paymentMethods[_random.nextInt(_paymentMethods.length)];
  }

  static double _randomDiscount() {
    if (_random.nextDouble() >= 0.2) {
      return 0;
    }

    return _randomBetween(5, 50).toDouble();
  }

  static double _calculatePaidAmount({
    required double total,
    required PaymentMethod method,
  }) {
    if (method != PaymentMethod.cash) {
      return _round(total);
    }

    // Cash customers pay with a rounded amount.
    final roundedAmount = (total / 10).ceil() * 10.0;

    return _round(roundedAmount);
  }

  static DateTime _randomTimeOnDate(DateTime date) {
    // Random time between 9:00 AM and 8:59 PM.
    final hour = 9 + _random.nextInt(12);
    final minute = _random.nextInt(60);
    final second = _random.nextInt(60);

    return DateTime(date.year, date.month, date.day, hour, minute, second);
  }

  static String _billNumber({required DateTime date, required int sequence}) {
    final datePart =
        '${date.year}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';

    return 'DEMO-$datePart-${sequence.toString().padLeft(5, '0')}';
  }

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static int _randomBetween(int min, int max) {
    return min + _random.nextInt(max - min + 1);
  }

  static double _round(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  static void _validate({
    required DateTime startDate,
    required DateTime endDate,
    required List<ProductEntity> products,
    required int minBillsPerDay,
    required int maxBillsPerDay,
    required int minItemsPerBill,
    required int maxItemsPerBill,
  }) {
    if (endDate.isBefore(startDate)) {
      throw ArgumentError('endDate cannot be before startDate');
    }

    if (products.isEmpty) {
      throw ArgumentError('Products list cannot be empty');
    }

    if (minBillsPerDay < 0 || maxBillsPerDay < minBillsPerDay) {
      throw ArgumentError('Invalid bills-per-day range');
    }

    if (minItemsPerBill <= 0 || maxItemsPerBill < minItemsPerBill) {
      throw ArgumentError('Invalid items-per-bill range');
    }
  }

  /// Generates bills for one specific calendar date.
  static List<BillEntity> generateBillsForDate({
    required DateTime date,
    required List<ProductEntity> products,
    int minBills = 3,
    int maxBills = 12,
    int minItemsPerBill = 1,
    int maxItemsPerBill = 6,
    String cashierId = 'dummy_cashier',
    String warehouseId = 'Main Store',
    bool synced = false,
    bool stockApplied = false,
  }) {
    _validate(
      startDate: date,
      endDate: date,
      products: products,
      minBillsPerDay: minBills,
      maxBillsPerDay: maxBills,
      minItemsPerBill: minItemsPerBill,
      maxItemsPerBill: maxItemsPerBill,
    );

    final usableProducts = products
        .where((product) => product.price.sellingPrice > 0)
        .toList();

    final bills = <BillEntity>[];
    final billDate = _dateOnly(date);

    final billsToday = _randomBetween(minBills, maxBills);

    for (var billIndex = 0; billIndex < billsToday; billIndex++) {
      final billDateTime = _randomTimeOnDate(billDate);

      final itemCount = _randomBetween(minItemsPerBill, maxItemsPerBill);

      final selectedProducts = _pickRandomProducts(usableProducts, itemCount);

      if (selectedProducts.isEmpty) {
        continue;
      }

      final items = _createBillItems(selectedProducts);

      final subtotal = items.fold<double>(
        0,
        (sum, item) => sum + item.unitPrice * item.quantity,
      );

      final tax = items.fold<double>(0, (sum, item) => sum + item.tax);

      final discount = _randomDiscount();

      final grandTotal = max(0.0, subtotal + tax - discount);

      final paymentMethod = _randomPaymentMethod();

      final paidAmount = _calculatePaidAmount(
        total: grandTotal,
        method: paymentMethod,
      );

      final payment = PaymentEntity(
        id: _uuid.v4(),
        method: paymentMethod,
        amount: paidAmount,
        paidAt: billDateTime,
      );

      final paymentSummary = PaymentSummaryEntity(
        payments: [payment],
        paidAmount: paidAmount,
        changeAmount: max(0.0, paidAmount - grandTotal),
        pendingAmount: 0,
      );

      bills.add(
        BillEntity(
          id: _uuid.v4(),
          billNumber: _billNumber(date: billDate, sequence: billIndex + 1),
          cashierId: cashierId,
          customer: null,
          items: items,
          subTotal: _round(subtotal),
          discount: _round(discount),
          tax: _round(tax),
          grandTotal: _round(grandTotal),
          payment: paymentSummary,
          status: BillStatus.completed,
          synced: synced,
          stockApplied: stockApplied,
          createdAt: billDateTime,
          updatedAt: billDateTime,
          warehouseId: warehouseId,
        ),
      );
    }

    return bills;
  }
}

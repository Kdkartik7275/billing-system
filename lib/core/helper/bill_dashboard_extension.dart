import 'package:billing_system/core/helper/generate_sku.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:fl_chart/fl_chart.dart';

class CategorySales {
  final String category;
  final double amount;

  CategorySales({required this.category, required this.amount});
}

extension BillsDashboardExtension on List<BillEntity> {
  List<String> getLast7DaysLabels() {
    final now = DateTime.now();

    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));

      switch (day.weekday) {
        case DateTime.monday:
          return 'Mon';
        case DateTime.tuesday:
          return 'Tue';
        case DateTime.wednesday:
          return 'Wed';
        case DateTime.thursday:
          return 'Thu';
        case DateTime.friday:
          return 'Fri';
        case DateTime.saturday:
          return 'Sat';
        case DateTime.sunday:
          return 'Sun';
        default:
          return '';
      }
    });
  }

  List<FlSpot> getWeeklySalesSpots() {
    final now = DateTime.now();

    return List.generate(7, (index) {
      final targetDate = now.subtract(Duration(days: 6 - index));

      final daySales = where(
        (bill) =>
            bill.createdAt.year == targetDate.year &&
            bill.createdAt.month == targetDate.month &&
            bill.createdAt.day == targetDate.day,
      ).fold<double>(0, (sum, bill) => sum + bill.grandTotal);

      return FlSpot(index.toDouble(), daySales);
    });
  }

  double getMaxWeeklySales() {
    final spots = getWeeklySalesSpots();

    if (spots.isEmpty) return 1000;

    final maxValue = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    if (maxValue <= 1000) return 1000;
    if (maxValue <= 3000) return 3000;
    if (maxValue <= 5000) return 5000;
    if (maxValue <= 10000) return 10000;

    return ((maxValue / 5000).ceil() * 5000).toDouble();
  }

  List<CategorySales> getSalesByCategory() {
    final Map<String, double> totals = {};

    for (final bill in this) {
      for (final item in bill.items) {
       
        final category = categoryFromSku(item.sku);
        totals[category] =
            (totals[category] ?? 0) + (item.unitPrice * item.quantity);
      }
    }

    return totals.entries
        .map((e) => CategorySales(category: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }

  double getTotalCategorySales() {
    return getSalesByCategory().fold(0, (sum, item) => sum + item.amount);
  }
}

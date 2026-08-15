import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({super.key, this.width, this.height = 300});

  final double? width;
  final double height;

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int _touched = -1;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillingController>();
    final tt = Theme.of(context).textTheme;

    return Obx(() {
      final categories = controller.salesByCategory;
      final totalSales = controller.totalCategorySales;

      return ChartCard(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sales by Category', style: tt.titleMedium),

            const SizedBox(height: 8),

            if (categories.isEmpty)
              const Expanded(
                child: Center(child: Text('No sales data available')),
              )
            else
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: PieChart(
                        PieChartData(
                          startDegreeOffset: -90,
                          sectionsSpace: 2,
                          centerSpaceRadius: 32,

                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              setState(() {
                                _touched =
                                    (!event.isInterestedForInteractions ||
                                        response?.touchedSection == null)
                                    ? -1
                                    : response!
                                          .touchedSection!
                                          .touchedSectionIndex;
                              });
                            },
                          ),

                          sections: List.generate(categories.length, (i) {
                            final item = categories[i];
                            final isTouched = i == _touched;

                            return PieChartSectionData(
                              value: item.amount,
                              color: categoryColor(item.category),
                              radius: isTouched ? 70 : 60,
                              showTitle: false,
                            );
                          }),
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      flex: 4,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (context, i) {
                          final item = categories[i];

                          final percentage = totalSales == 0
                              ? 0
                              : (item.amount / totalSales * 100);

                          final isSelected = i == _touched;
                          final color = categoryColor(item.category);

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _touched = _touched == i ? -1 : i;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? color.withValues(alpha: 0.08)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  // Color indicator
                                  Container(
                                    width: 11,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Category name
                                  Expanded(
                                    child: Text(
                                      item.category,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: tt.bodyMedium,
                                    ),
                                  ),

                                  const SizedBox(width: 4),

                                  // Percentage
                                  Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: tt.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}

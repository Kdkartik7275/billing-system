import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/core/indicators/category_chart_loading.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryPieChart extends StatefulWidget {
  const CategoryPieChart({super.key, this.width, this.height = 340});

  final double? width;
  final double height;

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int _touched = -1;

  static const highlight = Color(0xFFFF9F1C);

  String _formatCurrency(double value) {
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(1)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillingController>();
    final tt = Theme.of(context).textTheme;

    return Obx(() {
      // Loading state
      if (controller.loading.value) {
        return ChartCard(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(16),
          child: const CategoryPieChartSkeleton(),
        );
      }

      final categories = controller.salesByCategory;
      final totalSales = controller.totalCategorySales;
      final hasData = categories.isNotEmpty && totalSales > 0;

      // Empty state
      if (!hasData) {
        return ChartCard(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sales by Category',
                style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.pie_chart_outline_rounded,
                        size: 32,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No category data for this period',
                        style: tt.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      final average = totalSales / categories.length;
      final bestCategory = categories.reduce(
        (a, b) => a.amount > b.amount ? a : b,
      );

      return ChartCard(
        width: widget.width,
        height: widget.height,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Sales by Category',
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatCurrency(totalSales)} total · ${_formatCurrency(average)} avg/category',
              style: tt.bodySmall?.copyWith(color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Chart + legend (takes remaining space)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Pie chart
                  Expanded(
                    flex: 4,
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        sectionsSpace: 2,
                        centerSpaceRadius: 28,
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
                          final percent = totalSales == 0
                              ? 0
                              : (item.amount / totalSales * 100);

                          return PieChartSectionData(
                            value: item.amount,
                            color: categoryColor(item.category),
                            radius: isTouched ? 56 : 50,
                            title: isTouched
                                ? '${percent.toStringAsFixed(0)}%'
                                : '',
                            titleStyle: tt.bodySmall!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }),
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),

                  // Gap between chart and legend
                  const SizedBox(width: 18),

                  // Legend list
                  Expanded(
                    flex: 4,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
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
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color.withValues(alpha: 0.08)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Color indicator
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Category name + amount
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.category,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: tt.bodySmall!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                          fontSize: 11.5,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        _formatCurrency(item.amount),
                                        style: tt.bodyMedium!.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade900,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // Percentage badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: tt.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                      fontSize: 11,
                                    ),
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

            const SizedBox(height: 16),

            // Insight box (below chart, no overlap)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: highlight.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 16,
                      color: highlight,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${bestCategory.category} is your top category with '
                      '${_formatCurrency(bestCategory.amount)} '
                      '(${((bestCategory.amount / totalSales) * 100).toStringAsFixed(0)}% of total).',
                      style: tt.bodySmall?.copyWith(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

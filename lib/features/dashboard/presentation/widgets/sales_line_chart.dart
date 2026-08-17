import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesLineChart extends GetView<BillingController> {
  const SalesLineChart({super.key, this.height = 420});

  final double height;

  String _formatCurrency(double value) {
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(1)}L';
    if (value >= 1000) return '₹${(value / 1000).toStringAsFixed(1)}K';
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final primary = theme.colorScheme.primary;
    const highlight = Color(0xFFFF9F1C);

    return Obx(() {
      final spots = controller.weeklySalesSpots;
      final labels = controller.last7DaysLabels;
      final hasData = spots.isNotEmpty && spots.any((s) => s.y > 0);

      if (!hasData) {
        return ChartCard(
          height: height,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No sales data for this period',
              style: tt.bodyMedium?.copyWith(color: Colors.grey.shade500),
            ),
          ),
        );
      }

      final values = spots.map((s) => s.y).toList();
      final total = values.fold<double>(0, (a, b) => a + b);
      final average = total / values.length;
      final maxVal = values.reduce((a, b) => a > b ? a : b);
      final bestIndex = values.indexOf(maxVal);
      final bestLabel = bestIndex < labels.length ? labels[bestIndex] : '';
      final pctAboveAvg = average == 0
          ? 0
          : (((maxVal - average) / average) * 100).round();

      final maxY = maxVal * 1.25;
      final interval = maxY / 4;

      return ChartCard(
        height: height,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Overview - Last 7 Days',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatCurrency(total)} total · ${_formatCurrency(average)} avg/day',
                      style: tt.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BarChart(
                duration: const Duration(milliseconds: 450),
                curve: Curves.easeOutCubic,
                BarChartData(
                  minY: 0,
                  maxY: maxY,
                  alignment: BarChartAlignment.spaceEvenly,

                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.black87,
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final pctOfWeek = total == 0
                            ? 0
                            : ((rod.toY / total) * 100).round();
                        return BarTooltipItem(
                          '${_formatCurrency(rod.toY)}\n',
                          tt.bodySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text: '$pctOfWeek% of week',
                              style: tt.bodySmall?.copyWith(
                                color: Colors.white70,
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: Colors.grey.shade100, strokeWidth: 1),
                  ),

                  borderData: FlBorderData(show: false),

                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: average,
                        color: Colors.grey.shade400,
                        strokeWidth: 1.5,
                        dashArray: [6, 4],
                        label: HorizontalLineLabel(
                          show: true,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(bottom: 4, right: 4),
                          style: tt.bodySmall?.copyWith(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          labelResolver: (_) =>
                              'Avg ${_formatCurrency(average)}',
                        ),
                      ),
                    ],
                  ),

                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 46,
                        interval: interval,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) return const SizedBox.shrink();
                          return Text(
                            _formatCurrency(value),
                            style: tt.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          final isBest = index == bestIndex;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              labels[index],
                              style: tt.bodySmall?.copyWith(
                                color: isBest
                                    ? highlight
                                    : Colors.grey.shade600,
                                fontSize: 11,
                                fontWeight: isBest
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  barGroups: List.generate(spots.length, (i) {
                    final isBest = i == bestIndex;
                    final value = spots[i].y;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          width: 36,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: isBest
                                ? [highlight.withValues(alpha: 0.75), highlight]
                                : [primary.withValues(alpha: 0.55), primary],
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY,
                            color: Colors.grey.shade50,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: highlight.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: highlight,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      pctAboveAvg > 0
                          ? '$bestLabel was your best day — $pctAboveAvg% above your weekly average.'
                          : 'Sales were steady across the week with no standout day.',
                      style: tt.bodySmall?.copyWith(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
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

import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:billing_system/features/reports/presentation/widgets/report_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TenderBreakdownCard extends StatelessWidget {
  final ReportsController controller;

  const TenderBreakdownCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final slices = List<TenderSlice>.from(controller.tenderBreakdown)
        ..sort((a, b) => b.amount.compareTo(a.amount));

      final total = slices.fold<double>(0, (sum, item) => sum + item.amount);

      return ReportCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tender Breakdown',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            if (total <= 0)
              const SizedBox(
                height: 180,
                child: Center(
                  child: Text(
                    'No sales available',
                    style: TextStyle(color: AppColors.textPlaceholder),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 370;

                  return isCompact
                      ? _buildCompactLayout(slices: slices, total: total)
                      : _buildWideLayout(
                          slices: slices,
                          total: total,
                          availableWidth: constraints.maxWidth,
                        );
                },
              ),
          ],
        ),
      );
    });
  }

  Widget _buildWideLayout({
    required List<TenderSlice> slices,
    required double total,
    required double availableWidth,
  }) {
    final chartSize = availableWidth >= 500 ? 168.0 : 130.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _TenderPieChart(slices: slices, total: total, chartSize: chartSize),
        const SizedBox(width: 20),
        Container(
          width: 1,
          height: chartSize * .85,
          color: AppColors.textPlaceholder.withValues(alpha: .15),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < slices.length; i++)
                _TenderLegendRow(
                  slice: slices[i],
                  total: total,
                  isTop: i == 0 && slices.length > 1,
                  isLast: i == slices.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout({
    required List<TenderSlice> slices,
    required double total,
  }) {
    const chartSize = 150.0;

    return Column(
      children: [
        _TenderPieChart(slices: slices, total: total, chartSize: chartSize),
        const SizedBox(height: 20),
        for (int i = 0; i < slices.length; i++)
          _TenderLegendRow(
            slice: slices[i],
            total: total,
            isTop: i == 0 && slices.length > 1,
            isLast: i == slices.length - 1,
          ),
      ],
    );
  }
}

class _TenderPieChart extends StatelessWidget {
  final List<TenderSlice> slices;
  final double total;
  final double chartSize;

  const _TenderPieChart({
    required this.slices,
    required this.total,
    required this.chartSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: chartSize,
      width: chartSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: chartSize * .3,
              startDegreeOffset: -90,
              sections: [
                for (final slice in slices)
                  PieChartSectionData(
                    value: slice.amount,
                    color: slice.color,
                    radius: chartSize * .2,
                    showTitle: false,
                  ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formatReportCurrency(total),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Total sales',
                style: TextStyle(
                  color: AppColors.textPlaceholder,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TenderLegendRow extends StatelessWidget {
  final TenderSlice slice;
  final double total;
  final bool isTop;
  final bool isLast;

  const _TenderLegendRow({
    required this.slice,
    required this.total,
    required this.isTop,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : (slice.amount / total) * 100;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        slice.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isTop) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: slice.color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Most used',
                          style: TextStyle(
                            color: slice.color,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatReportCurrency(slice.amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 34,
                child: Text(
                  '${percentage.round()}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.textPlaceholder,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 5,
              child: Stack(
                children: [
                  Container(
                    color: AppColors.textPlaceholder.withValues(alpha: .12),
                  ),
                  FractionallySizedBox(
                    widthFactor: (percentage / 100).clamp(0.0, 1.0),
                    child: Container(color: slice.color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

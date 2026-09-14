import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/core/helper/functions.dart';
import 'package:billing_system/features/reports/presentation/controller/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportDaySummaryHeader extends StatelessWidget {
  final ReportsController controller;

  const ReportDaySummaryHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xffD7E8FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.primary,
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Day Summary',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat(
                          'dd MMM yyyy',
                        ).format(controller.selectedDate.value),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(status: controller.dayStatus.value),
              ],
            ),
            const SizedBox(height: 10),
            Container(height: 1, color: const Color(0xffD8E8FF)),
            LayoutBuilder(
              builder: (context, constraints) {
                final metrics = [
                  _Metric(
                    icon: Icons.currency_rupee,
                    color: AppColors.primary,
                    label: 'Total Sales',
                    value: controller.totalSales,
                    subtitle: '${controller.totalBillsCount} bills',
                  ),
                  _Metric(
                    icon: Icons.payments_outlined,
                    color: AppColors.primary,
                    label: 'Cash Sales',
                    value: controller.cashSales,
                    subtitle: '${controller.cashBillsCount} bills',
                  ),
                  _Metric(
                    icon: Icons.credit_card_outlined,
                    color: AppColors.primary,
                    label: 'Card Sales',
                    value: controller.cardSales,
                    subtitle: '${controller.cardBillsCount} bills',
                  ),
                  _Metric(
                    icon: Icons.account_balance_wallet_outlined,

                    color: AppColors.primary,
                    label: 'UPI Sales',
                    value: controller.upiSales,
                    subtitle: '${controller.upiBillsCount} bills',
                  ),
                ];

                final isCompact = constraints.maxWidth < 540;

                if (isCompact) {
                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: metrics.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3,
                        ),
                    itemBuilder: (_, i) => metrics[i],
                  );
                }

                return IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < metrics.length; i++) ...[
                          if (i != 0)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                                color: Color(0xffD8E8FF),
                              ),
                            ),
                          Expanded(child: metrics[i]),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DayStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOpen = status == DayStatus.open;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: isOpen
            ? AppColors.green.withValues(alpha: 0.1)
            : const Color(0xffECEFF3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: isOpen ? AppColors.green : AppColors.textSecondary,

          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final double value;
  final String subtitle;

  const _Metric({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 13, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatReportCurrency(value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$label · $subtitle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:billing_system/features/dashboard/presentation/models/dashboard_card_model.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/category_pie_chart.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/low_stocks.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/sales_line_chart.dart';
import 'package:billing_system/features/pos/domain/entity/bill_entity.dart';
import 'package:billing_system/features/pos/presentation/controller/bills_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileDashboardBody extends GetView<BillsController> {
  const MobileDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Obx(() {
          final cards = [
            DashboardCardModel(
              title: "Today's Sales",
              value: "₹${controller.todaySales.toStringAsFixed(0)}",
              growth: "${controller.todayOrderCount} orders today",
              icon: Icons.attach_money,
              iconColor: Colors.green,
            ),
            DashboardCardModel(
              title: "Total Orders",
              value: "${controller.todayOrderCount}",
              growth: "bills today",
              icon: Icons.shopping_cart_outlined,
              iconColor: Colors.blue,
            ),
            DashboardCardModel(
              title: "Revenue",
              value: "₹${controller.todayRevenue.toStringAsFixed(0)}",
              growth: "excl. tax",
              icon: Icons.show_chart,
              iconColor: Colors.deepPurple,
            ),
            DashboardCardModel(
              title: "Pending Sync",
              value: "${controller.pendingSyncCount}",
              growth: controller.pendingSyncCount == 0
                  ? "No pending bills"
                  : "${controller.pendingSyncCount} need sync",
              icon: Icons.pending_actions_outlined,
              iconColor: Colors.orange,
            ),
          ];
          return LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 10) / 2;
              final cardHeight = cardWidth * 0.55;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: cardWidth / cardHeight,
                children: cards
                    .map((c) => _MobileSummaryCard(data: c))
                    .toList(),
              );
            },
          );
        }),
        const SizedBox(height: 14),
        const SalesLineChart(height: 260),
        const SizedBox(height: 16),
        const CategoryPieChart(height: 280),
        const SizedBox(height: 16),
        const _RecentTransactions(),
        const SizedBox(height: 24),
        LowStockAlerts(),
      ],
    );
  }
}

class _MobileSummaryCard extends StatelessWidget {
  const _MobileSummaryCard({required this.data});
  final DashboardCardModel data;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ChartCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.growth,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: tt.bodySmall?.copyWith(
                    color: Colors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 18),
          ),
        ],
      ),
    );
  }
}

class _RecentTransactions extends GetView<BillsController> {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ChartCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Transactions', style: tt.titleMedium),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${controller.todayOrderCount} today',
                    style: tt.bodySmall?.copyWith(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final todayBills = controller.todayBills.take(5).toList();
            return Column(
              children: todayBills.isEmpty
                  ? [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No transactions today',
                          style: tt.bodyMedium?.copyWith(
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ]
                  : todayBills.map((tx) => _TransactionRow(tx: tx)).toList(),
            );
          }),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx});
  final BillEntity tx;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.receipt_outlined,
              size: 18,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.receiptNumber,
                  style: tt.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                Text(
                  tx.createdAt.toString().substring(0, 16),
                  style: tt.bodySmall?.copyWith(
                    color: Colors.grey.shade800,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (tx.subtotal + tx.taxAmount).toStringAsFixed(2),
                style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: tx.status == BillStatus.completed
                      ? Colors.green.withValues(alpha: 0.10)
                      : Colors.orange.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tx.status == BillStatus.completed ? 'Completed' : 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: tx.status == BillStatus.completed
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

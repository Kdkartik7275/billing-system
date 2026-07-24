import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_card_model.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/category_pie_chart.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/low_stocks.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/recent_transactions.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/sales_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const kTransactions = [
  TransactionData('INV-2026-001', 'Rajesh Kumar', '₹2,450', true),
  TransactionData('INV-2026-002', 'Priya Sharma', '₹3,680', true),
  TransactionData('INV-2026-003', 'Walk-in Customer', '₹890', true),
  TransactionData('INV-2026-004', 'Amit Verma', '₹1,240', false),
];

class DashboardBody extends StatelessWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _WebSummaryCards(),
          const SizedBox(height: 24),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded(child: SalesLineChart()),
              // SizedBox(width: 16),
          //   CategoryPieChart(width: 400, height: 300),
            ],
          ),
          SizedBox(height: 22),
          Row(
            children: [
              // Expanded(child: RecentTransactions()),
              // const SizedBox(width: 16),
              // Expanded(child: LowStockAlerts()),
            ],
          ),
        ],
      ),
    );
  }
}

class _WebSummaryCards extends StatelessWidget {
  const _WebSummaryCards();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final perRow = w < 650
            ? 1
            : w < 1000
            ? 2
            : w < 1400
            ? 3
            : 4;
        final itemWidth = (w - (perRow - 1) * 16) / perRow;
        return Obx(() {
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                [
                      DashboardCardModel(
                        title: "Today's Sales",
                        value: "₹${0}",
                        growth: "${0} orders today",
                        icon: Icons.attach_money,
                        iconColor: Colors.green,
                      ),
                      DashboardCardModel(
                        title: "Total Orders",
                        value: "${0}",
                        growth: "bills today",
                        icon: Icons.shopping_cart_outlined,
                        iconColor: Colors.blue,
                      ),
                      DashboardCardModel(
                        title: "Revenue",
                        value: "₹${0}",
                        growth: "excl. tax",
                        icon: Icons.show_chart,
                        iconColor: Colors.deepPurple,
                      ),
                      DashboardCardModel(
                        title: "Pending Sync",
                        value: "${0}",
                        growth: "No pending bills",
                        icon: Icons.pending_actions_outlined,
                        iconColor: Colors.orange,
                      ),
                    ]
                    .map(
                      (c) => SizedBox(
                        width: itemWidth,
                        child: _WebSummaryCard(data: c),
                      ),
                    )
                    .toList(),
          );
        });
      },
    );
  }
}

class _WebSummaryCard extends StatelessWidget {
  const _WebSummaryCard({required this.data});
  final DashboardCardModel data;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ChartCard(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: tt.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.value,
                  style: tt.headlineSmall?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.growth,
                  style: tt.bodySmall?.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(data.icon, color: data.iconColor),
          ),
        ],
      ),
    );
  }
}

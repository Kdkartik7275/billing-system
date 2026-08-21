import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/category_pie_chart.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_stats_panel.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/low_stocks.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/recent_transactions.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/sales_line_chart.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/tablet_info_card.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardWebBody extends StatelessWidget {
  const DashboardWebBody({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    const double headerHeight = 96;
    final user = Get.find<UserController>().user;

    return Stack(
      children: [
        // Dark strip the info card overlaps
        Container(height: 230 + topInset, color: const Color(0xFF0F0F14)),

        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 130 + topInset, 24, 24),
          child: Column(
            children: [
              const TabletSmartPosCard(),
              const SizedBox(height: 24),
              _WebSummaryCards(),
              const SizedBox(height: 24),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SalesLineChart()),
                  SizedBox(width: 16),
                  CategoryPieChart(width: 400, height: 300),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Expanded(child: RecentTransactions()),
                  const SizedBox(width: 16),
                  Expanded(child: LowStockAlerts()),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: headerHeight + topInset,
            color: const Color(0xFF0F0F14),
            padding: EdgeInsets.fromLTRB(24, topInset + 20, 24, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Hello, ${user.value?.name ?? ''}',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Here's what's happening today",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WebSummaryCards extends GetView<BillingController> {
  const _WebSummaryCards();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = [
        DashboardStatItem(
          title: "Today's Sales",
          value:
              "₹${controller.formatCompactValue(controller.todaysSalesRevenue)}",
          growth: "${controller.todaysBills.length} orders today",
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        DashboardStatItem(
          title: "Total Orders",
          value: "${controller.todaysBills.length}",
          growth: "bills today",
          icon: Icons.shopping_cart_outlined,
          color: Colors.blue,
        ),
        DashboardStatItem(
          title: "Items Sold",
          value: "${controller.todaysItemsSold}",
          growth: "units today",
          icon: Icons.inventory_2_outlined,
          color: Colors.deepPurple,
        ),
        DashboardStatItem(
          title: "Pending Sync",
          value: "${controller.pending.length}",
          growth: "No pending bills",
          icon: Icons.pending_actions_outlined,
          color: Colors.orange,
        ),
      ];
      return DashboardStatsPanel(items: items);
    });
  }
}

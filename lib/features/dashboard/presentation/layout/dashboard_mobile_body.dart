import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/category_pie_chart.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_stats_panel.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/mobile_info_card.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/low_stocks.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/recent_transactions.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/sales_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileDashboardBody extends StatelessWidget {
  const MobileDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    final billController = Get.find<BillingController>();
    return Stack(
      children: [
        Container(height: 56, color: const Color(0xFF0F0F14)),
        RefreshIndicator(
          onRefresh: () async {
            final dashboardController = Get.find<DashboardShellController>();
            await dashboardController.refreshDashboard();
          },
          backgroundColor: Colors.white,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            children: [
              const SmartPosInfoCard(),
              const SizedBox(height: 16),
              Obx(() {
                final items = [
                  DashboardStatItem(
                    title: "Today's Sales",
                    value: "₹${0}",
                    growth: "${0} orders today",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                  DashboardStatItem(
                    title: "Total Orders",
                    value: "${billController.todaysBills.length}",
                    growth: "bills today",
                    icon: Icons.shopping_cart_outlined,
                    color: Colors.blue,
                  ),
                  DashboardStatItem(
                    title: "Revenue",
                    value: "₹${0}",
                    growth: "excl. tax",
                    icon: Icons.show_chart,
                    color: Colors.deepPurple,
                  ),
                  DashboardStatItem(
                    title: "Pending Sync",
                    value: "${billController.pending.length}",
                    growth: "No pending bills",
                    icon: Icons.pending_actions_outlined,
                    color: Colors.orange,
                  ),
                ];
                return DashboardStatsPanel(items: items);
              }),
              const SizedBox(height: 14),
              const SalesLineChart(height: 260),
              const SizedBox(height: 16),
              const CategoryPieChart(height: 280),
              const SizedBox(height: 16),
              const RecentTransactions(),
              const SizedBox(height: 24),
              LowStockAlerts(),
            ],
          ),
        ),
      ],
    );
  }
}

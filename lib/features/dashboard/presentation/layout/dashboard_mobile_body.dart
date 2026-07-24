import 'package:billing_system/core/config/theme/app_colors.dart';
import 'package:billing_system/features/dashboard/presentation/controller/dashboard_shell_controller.dart';
import 'package:billing_system/features/dashboard/presentation/models/dashboard_card_model.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/chart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileDashboardBody extends StatelessWidget {
  const MobileDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final dashboardController = Get.find<DashboardShellController>();
        await dashboardController.refreshDashboard();
      },
      backgroundColor: Colors.white,
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Obx(() {
          //   final cards = [
          //     DashboardCardModel(
          //       title: "Today's Sales",
          //       value: "₹${0}",
          //       growth: "${0} orders today",
          //       icon: Icons.attach_money,
          //       iconColor: Colors.green,
          //     ),
          //     DashboardCardModel(
          //       title: "Total Orders",
          //       value: "${0}",
          //       growth: "bills today",
          //       icon: Icons.shopping_cart_outlined,
          //       iconColor: Colors.blue,
          //     ),
          //     DashboardCardModel(
          //       title: "Revenue",
          //       value: "₹${0}",
          //       growth: "excl. tax",
          //       icon: Icons.show_chart,
          //       iconColor: Colors.deepPurple,
          //     ),
          //     DashboardCardModel(
          //       title: "Pending Sync",
          //       value: "${0}",
          //       growth: "No pending bills",
          //       icon: Icons.pending_actions_outlined,
          //       iconColor: Colors.orange,
          //     ),
          //   ];
          //   return LayoutBuilder(
          //     builder: (context, constraints) {
          //       final cardWidth = (constraints.maxWidth - 10) / 2;
          //       final cardHeight = cardWidth * 0.55;
          //       return GridView.count(
          //         crossAxisCount: 2,
          //         shrinkWrap: true,
          //         physics: const NeverScrollableScrollPhysics(),
          //         crossAxisSpacing: 10,
          //         mainAxisSpacing: 10,
          //         childAspectRatio: cardWidth / cardHeight,
          //         children: cards
          //             .map((c) => _MobileSummaryCard(data: c))
          //             .toList(),
          //       );
          //     },
          //   );
          // }),
          const SizedBox(height: 14),
          // const SalesLineChart(height: 260),
          // const SizedBox(height: 16),
          // const CategoryPieChart(height: 280),
          // const SizedBox(height: 16),
          // const RecentTransactions(),
          // const SizedBox(height: 24),
          // LowStockAlerts(),
        ],
      ),
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

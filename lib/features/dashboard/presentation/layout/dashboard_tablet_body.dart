import 'package:billing_system/core/enums/billing.dart';
import 'package:billing_system/features/billing/domain/entities/bill_entity.dart';
import 'package:billing_system/features/billing/presentation/controllers/billing_controller.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/category_pie_chart.dart';
import 'package:billing_system/core/config/theme/app_radius.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/logout_button.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/tablet_info_card.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/dashboard_stats_panel.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/low_stocks.dart';
import 'package:billing_system/features/dashboard/presentation/widgets/sales_line_chart.dart';
import 'package:billing_system/features/user/presentation/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabletDashboardBody extends GetView<BillingController> {
  const TabletDashboardBody({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    const double headerHeight = 96;
    final user = Get.find<UserController>().user.value;

    return Stack(
      children: [
        Container(height: 230 + topInset, color: const Color(0xFF0F0F14)),

        ListView(
          padding: EdgeInsets.fromLTRB(20, 130 + topInset, 20, 12),
          children: [
            const TabletSmartPosCard(),
            const SizedBox(height: 20),
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
                  value: "${controller.todaysBills.length}",
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
                  value: "${controller.pending.length}",
                  growth: "No pending bills",
                  icon: Icons.pending_actions_outlined,
                  color: Colors.orange,
                ),
              ];
              return DashboardStatsPanel(items: items);
            }),
            const SizedBox(height: 12),
            const SalesLineChart(height: 260),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 480) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: CategoryPieChart(height: 300)),
                      const SizedBox(width: 10),
                      Expanded(child: _TabletTransactions()),
                    ],
                  );
                }
                return Column(
                  children: [const SizedBox(height: 12), _TabletTransactions()],
                );
              },
            ),
            const SizedBox(height: 24),
            const LowStockAlerts(),
            const SizedBox(height: 12),
          ],
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
                          'Hello, ${user?.name ?? ''} ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                const LogoutButton(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TabletTransactions extends GetView<BillingController> {
  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.todaysBills.length} today',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final todayBills = controller.todaysBills.take(5).toList();
            if (todayBills.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No transactions today',
                    style: tt.bodyMedium?.copyWith(color: Colors.grey.shade500),
                  ),
                ),
              );
            }
            return Column(
              children: todayBills.map((tx) => _TxRow(tx: tx)).toList(),
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.tx});
  final BillEntity tx;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: Color(0xFFF0F0F0)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.receipt_outlined,
                  size: 15,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.billNumber,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      tx.createdAt.toString().substring(0, 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    (tx.subTotal + tx.tax).toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: tx.status == BillStatus.completed
                          ? const Color(0xFF22C55E).withValues(alpha: 0.12)
                          : const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tx.status == BillStatus.completed ? 'Done' : 'Pending',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: tx.status == BillStatus.completed
                            ? const Color(0xFF16A34A)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
